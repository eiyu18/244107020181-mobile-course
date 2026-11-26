# Week 13 - CI/CD and the workflow

![](./Screenshots/Analyze.png)
![](./Screenshots/Aresult.png)
![](./Screenshots/Test.png)
![](./Screenshots/Tresult.png)


# Reflection

1. What problem was detected automatically before changes were merged?

The workflow checks formatting, static analysis and tests on every pull request, so problems are caught before they reach main.

2. What information would help you investigate a failed build?

The key thing to look at is which step failed and what its log says. That tells you whether the issue is formatting, code analysis, a test, or the Android build.

3. What still needs approval or manual review before a release?

The APK is built in release mode, but it isn't signed with a production key, so it can't go to the Play Store yet. A tester still needs to review the app and check permissions like notifications. Also check that the Gemini API key isn't exposed, because anyone can pull a key out of the APK. The integration tests don't run in this workflow, so login, search, and the detail page must be tested by hand on a phone.