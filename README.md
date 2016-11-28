# Board For GitHub

A small application to monitor your GitHub project web page in a native macOS app :octocat:!

![](https://raw.githubusercontent.com/JustinFincher/BoardForGitHub/master/DemoImgs/Banner.jpg)

---

# System Requirement

10.12, maybe 10.11 and 10.10, but I am not sure because I used a new enum (from 10.12) with `self.window.styleMask` in `JZWindowController.m` and I don't know if it will fall back to the equal state when in previous version of macOS.

---

# How to use

If this is the first time you open the app, you will be redirected to the login page.  
And shows the default project :   
![](https://raw.githubusercontent.com/JustinFincher/BoardForGitHub/master/DemoImgs/1.jpg)

Then click the octocat icon ( upper-left, next to window buttons ), a dialog will open asking project url. Fill it and click OK to load web page and also save it in userdefaults so next time this app will load this url automatically.  
![](https://raw.githubusercontent.com/JustinFincher/BoardForGitHub/master/DemoImgs/2.jpg)

---

# Release

Go [Releases](https://github.com/JustinFincher/BoardForGitHub/releases)
