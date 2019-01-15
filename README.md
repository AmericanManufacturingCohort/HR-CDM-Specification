This repository houses the main source of the AMC HR-CDM Specification document and we welcome public participations to contribute to the development of the specification.

The document is accessible as a wiki page at [https://github.com/AmericanManufacturingCohort/HR-CDM-Specification/wiki](https://github.com/AmericanManufacturingCohort/HR-CDM-Specification/wiki)

# Contributing to the AMC HR-CDM Specification Document

Using the Github resource management system, you can propose a file change to the source document and we will integrate the changes if they are relevant and useful. The guide below gives you a step-by-step instruction on how to contribute to the development of the AMC HR-CDM specification document.

> IMPORTANT: You will need a Github account to be able to follow the instructions. Go to [https://github.com/join](https://github.com/join) to register a new account and come back here again once you are able to sign in with your Github account.

***Step 1: Find the file***

Go to the **Wiki** folder and look for the file that contains the page that you want to contribute. We used the same name for the file and the titles found in the wiki's table of contents. Once you find it, click on the file to proceed.

***Step 2: Make the change***

Click the "Edit" icon on the right hand side to open a text editor where you can access the raw text and make your changes. The raw text uses a formatting syntax called Markdown ([see full description](https://help.github.com/articles/basic-writing-and-formatting-syntax/)). Use the "Preview changes" tab to visualize the resulting text.

***Step 3: Propose the change***

After you are satisfied with the changes, look at the bottom of the page and find a section called "Propose file change". Add a brief comment about the change (this is mandatory) and if you wish, you could add a more detailed description to help us understand the changes. Click the "Propose file change" button to proceed.

***Step 4: Create a "pull request"***

The next page will allow you to review the changes that you have made. The red highlight indicates the part of the text that will get removed, and the green highlight indicates the new addition that will be added in the document (it may also indicate a replacement from the old text). Once you are happy with the changes and the comment text, click the "Create pull request" button and confirm it by clicking the same button again.

Repeat all the steps above for other files that you want to modify.

The next step will be on our side, such that, we will review the proposed changes, communicate with you about the change when it is necessary and accept (or reject) the changes based on our evaluation. If we accept the change, your text will appear in the wiki page and we will give an attribution for your contribution.

# Release Notes

* **v1.0**
 - Rename a variable `employment_status_concept_id` to `work_state` in the EMPLOYMENT_RECORD table. The value is no longer a coded status id but instead a string label value is used to describe the working state, e.g., "Work", "STD", "Terminate", and so on.
