## Change Invoice Status

### Objectives
This use case describes the possible statuses for the Invoice

### Preconditions
The administrator must be logged in  
There must be an Invoice in “Pending” status

### Postconditions
The Invoice has its status changed

### Flow of Events

### Basic Flow

1. The administrator goes to the Detail page of an Invoice which status is “Pending”
2. The system displays the Invoice Details
3. The system displays the buttons “Approve” and “Reject”
4. The administrator presses the “Approve” button
5. The system changes the Invoice status to “Approved”
6. The system refreshes the Invoice Detail page
7. The system hides the “Approve” and “Reject” buttons
8. The system displays the “Revert” and “Review” buttons
9. End of flow


### Alternative Flows

##### 1. The administrator rejects the pending Invoice (step 4 of the basic flow)
   1. The administrator presses the “Reject” button
   2. The system changes the Invoice status to “Rejected”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Approve” and “Reject” buttons
   5. The system displays the “Review” button
   6. End of flow

##### 2. The administrator reverts an approved Invoice (step 8 of the basic flow)
   1. The administrator presses the “Revert” button
   2. The system totally or partially removes the points given to the related member when the Invoice was approved
   3. The system changes the Invoice status to “Reverted”
   4. The system hides the “Revert” and “Review” buttons
   5. End of flow

##### 3. The administrator reviews an approved Invoice (step 8 of the basic flow)
   1. The administrator presses the “Review” button
   2. The system removes totally or partially the points given to the related member when the Invoice was approved
   3. The system changes the Invoice status to “Pending”
   4. The system hides the “Revert” and “Review” buttons
   5. The system displays the “Approve” and “Reject” buttons
   6. End of flow
   
##### 4. The administrator reviews a rejected Invoice (step 6 of the alternative flow 1)
   1. The administrator presses the “Review” button
   2. The system changes the Invoice status to “Pending” 
   3. The system hides the “Review” button
   4. The system displays the “Approve” and “Reject” buttons
   5. End of flow
