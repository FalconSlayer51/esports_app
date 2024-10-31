const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.generateMatches = onDocumentUpdated(
    "tournaments/{tournamentId}",
    async (event) => {
      const {tournamentId} = event.params;
      const tourData = event.data.after.data();
      const previousData = event.data.before.data();

      if (previousData.status === "upcoming" && tourData.status === "ongoing") {
      // Fetch the registered teams
        const registeredTeamsSnapshot = await db
            .collection("tournaments")
            .doc(tournamentId)
            .get();
        const registeredTeams = registeredTeamsSnapshot.data().teamsRegistered;

        // Create all possible match pairs for round-robin
        const matches = [];
        for (let i = 0; i < registeredTeams.length; i++) {
          for (let j = i + 1; j < registeredTeams.length; j++) {
            const matchId = db.collection("matches").doc().id;
            const match = {
              matchId: matchId,
              tournamentId: tournamentId,
              team1Id: registeredTeams[i],
              team2Id: registeredTeams[j],
              team1Score: 0,
              team2Score: 0,
              winnerId: null,
              status: "scheduled",
            };
            matches.push(match);
          }
        }

        // Add matches to Firestore in a batch
        const batch = db.batch();
        matches.forEach((m) => {
          const matchRef = db.collection("matches").doc(m.matchId);
          batch.set(matchRef, m);
        });

        await batch.commit();

        console.log("Round-robin match ", tournamentId);
      }

      return null;
    },
);
