# Objectives
• Design and implement screens for adding, listing, and editing player profiles.
• Use form fields, validation, and user input handling for managing player data.
• Implement interactive UI components such as search, swipe-to-delete, and sliders.
This module focuses on managing player profiles for a badminton queuing system. You will
create screens to add, view, edit, and remove players, ensuring the database of
participants stays accurate and up-to-date.

# Instructions

## Part 1: Add Player Profile Screen
1. Create a new screen titled "Add New Player".
2. Implement a form with the following input fields:
3. Nickname (text input)
4. Full Name (text input)
5. Contact Number (numeric input)
6. Email (email input)
7. Address (multiline text area)
8. Remarks (multiline text area)
9. Add a badminton level slider:
10.The slider should cover levels: Beginners → Intermediate → Level G → Level F → Level E → Level D → Open Player.
11.Each level should have three tick marks: Weak, Mid, Strong.
12.Use draggable handles to allow selection of a range.
13.Place action buttons to "Save Player" and “Cancel" the screen.
14.Ensure input validation: no empty required fields, valid email, and numeric-only phone number.

## Part 2: List All Player Profiles Screen
15.Create a new screen titled "All Players".
16.Add a search bar at the top to filter players by nickname or full name.
17.Display a list of player cards/rows containing:
18.Nickname
19.Full Name
20.Current badminton level
21.Add swipe-to-delete functionality:
22.Swiping reveals a Delete action.
23.Prompt the user for confirmation before deletion.
24.Add an action button for "Add New Player", which navigates to the Add Player screen.
25.Make player rows tappable to open the Edit Player Profile screen.

## Part 3: Edit Player Profile Screen
26.Create a new screen titled "Edit Player Profile".
27.Reuse the same layout as the Add Player screen.
28.Pre-fill fields with the selected player’s details.
29.Set the badminton level slider to the current values.
30.Add action buttons:
31."Update Player" – saves changes.
32."Cancel" – returns without saving.
33."Delete Player" – permanently removes the profile (with confirmation).
