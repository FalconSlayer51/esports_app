import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/tournaments/matches_list.dart';
import 'package:esports_app/tournaments/models/match_model.dart';
import 'package:esports_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiUrl =
      'https://newsapi.org/v2/everything?q=esports&apiKey=$API_KEY';
  List articles = [];

  Future<List<Match>> fetchMatches() async {
    final matches =
        await FirebaseFirestore.instance.collection('matches').get();
    return matches.docs.map((doc) => Match.fromFirestore(doc)).toList();
  }

  Future<Map<String, dynamic>> getTeamDetails(String teamId) async {
    final teamDoc =
        await FirebaseFirestore.instance.collection('users').doc(teamId).get();
    return teamDoc.data() ?? {};
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = data['articles'];
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Match>>(
              future: fetchMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No matches available"));
                }

                final matches = snapshot.data!;

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                  ),
                  items: matches.map((match) {
                    return Builder(
                      builder: (BuildContext context) {
                        return FutureBuilder(
                          future: Future.wait([
                            getTeamDetails(match.team1Id),
                            getTeamDetails(match.team2Id),
                          ]).then((teamData) => {
                                'team1': teamData[0],
                                'team2': teamData[1],
                              }),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Text("Error loading team data");
                            }

                            final team1 = snapshot.data!['team1'];
                            final team2 = snapshot.data!['team2'];

                            return ScoreCard(
                              matchId: match.matchId,
                              isOrganizer: false,
                              team1Name: team1?['displayName'] ?? 'Team 1',
                              team2Name: team2?['displayName'] ?? 'Team 2',
                              team1PhotoUrl: team1?['photoURL'] ?? '',
                              team2PhotoUrl: team2?['photoURL'] ?? '',
                              team1Score: match.team1Score ?? 0,
                              team2Score: match.team2Score ?? 0,
                              matchStatus: match.status ?? 'Pending',
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'News',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            // NEWS SECTION
            articles.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await launchUrl(Uri.parse(article['url']));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image (if available)
                              if (article['urlToImage'] != null)
                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                    child: Image.network(
                                      article['urlToImage'] ??
                                          'https://example.com/placeholder.jpg',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images.png', // Add a local placeholder image here
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      article['description'] ??
                                          'No description',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          article['publishedAt']
                                                  ?.substring(0, 10) ??
                                              '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
