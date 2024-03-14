<!--

This source file is part of the PICS based on the Stanford Spezi Template Application project

SPDX-FileCopyrightText: 2024 Stanford University

SPDX-License-Identifier: MIT

-->

# CS342 2024 PICS

[![Build and Test](https://github.com/CS342/2024-PICS/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/CS342/2024-PICS/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/CS342/2024-PICS/graph/badge.svg?token=4vc3Z0TQWh)](https://codecov.io/gh/CS342/2024-PICS)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10521603.svg)](https://doi.org/10.5281/zenodo.10521603)

This repository contains the CS342 2024 PICS application.
The CS342 2024 PICS application is using the [Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem and builds on top of the [Stanford Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).

> [!NOTE]  
> Do you want to try out the CS342 2024 PICS application? You can download it to your iOS device using [TestFlight](https://testflight.apple.com/join/oHPpBoKG)!

## Overview
The CS342 2024 PICS application allows patients recovering from intensive care therapy to better track their recovery and inform their doctors on their health. Patients fill out necessary hospital questionnaire through the application prior to their hospital visit and track their health vitals based on their Apple health data. 

## CS342 2024 PICS Features
Our application first allows users to create an account to help keep track of their information which includes taking an onboarding questionnaire to collect their basic information, uploading a photo of their medication plan, and entering their appointment information during the onboarding process. Once users have created an account, there are five main features. 

1. Appointments: Users can view their appointment time and the required documents to bring for each of their appointments. Users can also edit the appointment times in this view, and corresponding notifications will be sent 1 day earlier, 30 minutes earlier, and at the time of the appointment to remind users of their upcoming appointments. There is also a map in the bottom of the view to visualize the location of the appointments to help users navigate.


2. Questionnaires: Users can take the questionnaires required for each appointment directly through their phone. The questionnaires help users schedule when to take each questionnaire and show a check mark if the questionnaires are completed. Besides, if the users choose to skip the onboarding questionnaire during the onboarding process, the questionnaire will also show up in this tab.

3. Assessments: Users can take assessments to measure their cognitive abilities. Our application includes the trail-making test, Stroop test, and reaction time test to measure different aspects of the user's cognitive skills. Results will be displayed as a chart and users can click on a dot to see more details about the selected result. Otherwise, our app will show the user's last test result for each test.

4. Health Vitals: Users can view their health vitals (step counts, oxygen saturation, and heart rate) in the previous two weeks. Related details will be shown when users click on a specific bar or dot in the chart for users to learn more about their health condition. Besides, thresholds are set and shown as horizontal lines for step counts and 

5. Contacts: This page shows the contact information for the medical team and address information. The PICS app will direct users to the Apple Map for easier direction and navigation when users click on the address.

|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/MedicationView~dark.png"><img src="Resources/MedicationView.png" width="250" alt="Screenshot displaying the Medication View." /></picture>|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/AppointmentView~dark.png"><img src="Resources/AppointmentView.png" width="250" alt="Screenshot displaying the Appointments View." /></picture>|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/QuestionnaireView~dark.png"><img src="Resources/QuestionnaireView.png" width="250" alt="Screenshot displaying the Questionnaire View." /></picture>|
|:--:|:--:|:--:|
|`Medication View`|`Appointments View`|`Questionniare View`|

|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/AssessmentView~dark.png"><img src="Resources/AssessmentView.png" width="250" alt="Screenshot displaying the Assessment View." /></picture>|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/HealthDashboardView~dark.png"><img src="Resources/HealthDashboardView.png" width="250" alt="Screenshot displaying the Health Vitals View." /></picture>|<picture><source media="(prefers-color-scheme: dark)" srcset="Resources/ContactView~dark.png"><img src="Resources/ContactsView.png" width="250" alt="Screenshot displaying the Contacts View." /></picture>|
|:--:|:--:|:--:|
|`Assessments View`|`Health Vitals View`|`Contacts View`|
 
*Provide a comprehensive description of your application, including figures showing the application. You can learn more on how to structure a README in the [Stanford Spezi Documentation Guide](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/documentation-guide)*

> [!NOTE]  
> Do you want to learn more about the Stanford Spezi Template Application and how to use, extend, and modify this application? Check out the [Stanford Spezi Template Application documentation](https://stanfordspezi.github.io/SpeziTemplateApplication)

## Setup
1. See setup [instructions](https://spezi.health/SpeziTemplateApplication/documentation/templateapplication/setup/) for Spezi Application

## Contributing

Akanshya Bhat
- Appointments page (must-have): designed homepage, sending notifications, show appointment details, map location (can-have), timeline, required documents, edit appointment information
- Assessment page: starting code for assessments (trail-making task)
- Testing: For the Appointment and Contact page

Catherine Zhang:
- Onboarding Questionnaire: Create onboarding questionnaire that is optional during onboarding but must be completed on the dashboard before first appointment
- Medication Information: Create page on the onboarding flow that allows users to upload a photo of the medication sheet received at the hospital
- ReactionTime Assessment: Added the ReactionTime assessment to the assessment page using ResearchKit
- Testing: For the Onboarding Flow

Karan Soin
- Questionnaires Page: UI set up and refinement for the questionnaires page. Questionnaires Scheduler to schedule the questionnaires at appropriate times, intervals, and recurrences
- Assessment Tasks: Added the Stroop Test, UI Revamp and Refinement
- Testing: For the Questionnaires page

Yuren Sun:
- Health Vitals Page: Health dashboard page set up and refinement. HealthKit samples collection and health data visualization for step count, heart rate, and oxygen saturation
- Assessment Page: Basic UI and logic set-up of the page, assessment result parsing for Trail-making and Stroop, and visualization of results
- Testing: For the Onboarding Flow, HealthKit visualizations, and Assessment page


## License

This project is licensed under the MIT License. See [Licenses](LICENSES) for more information.
