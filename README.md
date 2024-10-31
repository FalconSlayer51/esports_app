
# Running the esports_app locally.

This guide walks you through the steps of cloning a Flutter project from GitHub and running it on your local machine.

## Prerequisites

* **Flutter SDK:** Ensure you have the Flutter SDK installed and configured.  You can download it from [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install).
* **Git:**  Make sure Git is installed on your system.  You can download it from [https://git-scm.com/downloads](https://git-scm.com/downloads).
* **IDE (Optional but Recommended):**  An IDE like Android Studio, IntelliJ IDEA, or VS Code with the Flutter extension simplifies development.
* **Device or Emulator:**  You'll need a physical Android or iOS device, or an emulator/simulator to run the app.

## Steps

1. **Find the GitHub Repository:** Locate the Flutter project you want to clone on GitHub. The repository URL will typically look like [https://github.com/FalconSlayer51/esports_app.git].

2. **Clone the Repository:** Open your terminal or command prompt and navigate to the directory where you want to store the project.  Then, use the `git clone` command:

   ```bash
   https://github.com/FalconSlayer51/esports_app.git
3. **Before running the project make sure you download `google-services.json` file from firebase project and paste the file in [android/app](android/app) folder.
4. **Add the `API KEY` in [lib/utils/constants.dart](lib/utils/constants.dart) file. you can get the api key from [https://newsapi.org/] website.
5. **Goto the root of project and type the following command.
     ```bash
         flutter run
