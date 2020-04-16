# FlowChart README
## Contributions
**Aparna Krishnan** (Release 25%, Overall 25%)
* Location-based resources screen using MapKit and CoreLocation, dynamically uses location to provide Apple recommended clinics. 
* Recent News page with integration with NewsAPI to provide recommended articles about women and health
* Checklist page that allows for selection and deletion that is saved to core data
* Firebase authentication and login and signup screens 
* Settings page with logout and notification settings. The notification settings are to be used for the final where we implement notifications. 
* Updating calendar based on user information stored in core data for accurate display

**Madeline Huang** (Release 25%, Overall 25%)
* Splash screen & logos
* Main screen, including the 3 different screen scenarios and desing the user will encounter based off of their period start date, end date, and whether not the user is on their period.
* Upcoming dates on the main screen are relative to today's date if within 2 weeks (ex: today, tomorrow, next Thursday)
* Menu interactivity and animation
* Worked with Abby to accurately update the display based on user core data 

**Shannon Radey** (Release 25%, Overall 25%)
* Calendar 
* Added functionality to the calendar story board to display icons for symptoms, ovulation, or periods as well as sliding to display the previous or next month as well as selecting a date to segue to tracker for that date.
* Added design design aspects to tracker as well as appropriate segues  
* Put in constraints on the calendar, tracker, login, settings, and resources pages so the displays can work on iPhones 8 through iPhone 11 Pro Max
* Added minimal design aspects to symptoms storyboard

**Soujanya Geddam** (Release 25%, Overall 25%)
* Built storyboards for tracker screens including symptoms, mood, and flow 
* Added functionality (image switching) based on button selection (in mood and flow VCs); also added functionality for symptoms selection and designed table view to display symptoms aesthetically 
* Implemented core data for the screens to save user and date specific information (ex: flow level, mood type)

## Deviations
* Splash screen will not display random fun facts as it is unabled to be modified due to Landing Screen's static nature
* Notifications will be implemented in the final instead of beta, as will the algorithm for predicting cycles. Right now "algorithim" uses base 30 days between cycle and 7 days for length of period. 
* Aesthetically pleasing/final UI is completed ahead of time
* Resources are dynamically (not hard-coded) generated and displayed with location ahead of time
