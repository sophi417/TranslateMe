# Project 6 - *TranslateMe*

Submitted by: **Sophia Sartor**

**TranslateMe** is an app that translates words and phrases using the MyMemory API and saves your translation history with Firebase Firestore.

Time spent: **6** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [x] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [x] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [x] The history of translations can be erased
 
The following **optional** features are implemented:

- [x] Add a variety of choices for the languages
- [x] Add UI flair

The following **additional** features are implemented:

- [x] Swap button to flip the two languages
- [x] History updates live from Firestore and stays after closing the app
- [x] Confirm alert before clearing history

## Video Walkthrough

Here's a walkthrough of implemented user stories:

https://youtube.com/shorts/w0INbSMCDZQ?feature=share

## Notes

Setting up Firebase was the hardest part. I had to link FirebaseFirestore to the target and add `import Combine` before it would build.

## License

    Copyright 2026 Sophia Sartor

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
