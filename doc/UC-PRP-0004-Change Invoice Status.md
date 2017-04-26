## Change Invoice Status

### Objectives
This use case describes the possible statuses for the Invoice

### Preconditions
The administrator must be logged in   
The approver must be logged in  
There must be at least one Invoice in “Draft” status  
There must be an approval process configured which updates the status of the invoice

### Postconditions
The Invoice has its status changed

### Flow of Events

### Basic Flow

   1. The administrator selects, in the Invoices landing page, an invoice which status is “Draft” from a program where the option “Request Invoice Authorization” is set to true
   2. The system displays the Invoice details page
   3. The system displays the "Edit" and “Close” buttons
   4. The administrator presses the “Close” button
   5. The system refreshes the Invoice details page
   6. The system changes the Invoice status to “Pending”
   7. The system submits the invoice to the configured approval process
   8. The system hides the “Edit” and “Close” buttons
   9. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   10. End of flow


### Alternative Flows

##### 1. The approver approves a pending invoice from a program where the option “Request Invoice Authorization” is set to true (step 9 of basic flow)
   1. The approver selects the action to “Approve/Reject” the invoice in the Approval Process area
   2. The system displays the approval process page
   3. The approver approves the invoice
   4. The system changes the Invoice status to “Approved”
   5. The system refreshes the Invoice details page
   6. The system displays the “Cancel” and “Reprocess” buttons
   7. End of flow

##### 2. The approver rejects a pending Invoice from a program where the option “Request Invoice Authorization” is set to true (step 9 of basic flow)
   1. The approver selects the action to “Approve/Reject” the invoice in the Approval Process area
   2. The system displays the approval process page
   3. The approver rejects the invoice
   4. The system changes the Invoice status to “Rejected”
   5. The system refreshes the Invoice details page
   6. The system displays the “Reopen” button
   7. End of flow

##### 3. The administrator closes a draft invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Draft” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Edit", “Close” and “Submit for Approval” buttons
   4. The administrator presses the “Close” button
   5. The system changes the Invoice status to “Approved”
   6. The system refreshes the Invoice details page
   7. The system hides the “Edit, “Close” and “Submit for Approval” buttons
   8. The system displays the “Cancel” and “Reprocess” buttons
   9. End of flow

##### 4. The administrator submits for approval a draft Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator selects, in the Invoices landing page, an invoice which status is “Draft” from a program where the option “Request Invoice Authorization” is set to false
   2. The system displays the Invoice details page
   3. The system displays the "Edit", “Close” and “Submit for Approval” buttons
   4. The administrator presses the “Submit for Approval” button
   5. The system refreshes the Invoice details page
   6. The system changes the Invoice status to “Pending”
   7. The system submits the invoice to the configured approval process
   8. The system hides the “Edit, “Close” and “Submit for Approval” buttons
   9. The system displays the actions to “Approve” or “Reject” the invoice in the Approval Process area
   10. End of flow

##### 5. The approver approves the pending Invoice from a program with no approval process required (step 1 of basic flow)
   1. The administrator presses the “Cancel” button
   2. The system changes the Invoice status to “Canceled”
   3. The system removes the points previously given to the related member
   4. The system refreshes the Invoice Detail page
   5. The system hides the “Cancel” button
   6. The system displays the “Reopen” button and maintains the “Reprocess” button
   7. End of flow

##### 6. The administrator reprocesses an approved Invoice (step 5 of the alternative flow 1 or step 7 of the alternative flow 2)
   1. The administrator presses the “Reprocess” button
   2. The system maintains the Invoice status in “Approved”
   3. The system reprocesses the invoice
   4. The system refreshes the Invoice Detail page
   5. The system maintains the “Cancel” and “Reprocess” buttons
   6. End of flow
   
##### 7. The administrator reopens a rejected Invoice (step 6 of the alternative flow 3)
   1. The administrator presses the “Reopen” button
   2. The system changes the Invoice status to “Draft” 
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reopen” button
   5. The system displays the “Approve” and “Submit for Approval” buttons
   6. End of flow

##### 8. The administrator reopens a canceled Invoice (step 6 of the alternative flow 5)
   1. The administrator presses the “Reopen” button
   2. The system changes the Invoice status to “Draft”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reopen” button
   5. The system displays the “Approve” and “Submit for Approval” buttons
   6. End of flow
   
##### 9. The administrator reprocesses a canceled Invoice (step 6 of the alternative flow 5)
   1. The administrator presses the “Reprocess” button
   2. The system changes the Invoice status to “Approved”
   3. The system refreshes the Invoice Detail page
   4. The system hides the “Reprocess” button
   5. The system displays the “Cancel” and “Reprocess” buttons
   6. End of flow
