## Display Invoice Details Page

### Objectives
The present use case describes how the system shows the Invoice details and the action buttons for each invoice status

### Preconditions
- There must be Invoices created for Programs that consider invoice items and for Programs that do not consider invoice items
- There must be Invoices in all status (Pending, Approved, Rejected and Reverted) for each Program
- The administrator must be logged in

### Postconditions
- The system displayed the details of the selected Invoice
- The system displayed the corresponding action buttons according to Invoice Status

### Flow of Events

### Basic Flow
1. The administrator presses the Invoices tab
2. The system shows the Invoices landing page 
3. The administrator selects a Program that considers invoice items
4. The administrator selects one of the Invoices of the selected Program, which status is Pending
5. The system displays the Invoice details page, containing:
   - Edit button
   - Approve button
   - Reject button
   - Fieldset of Invoice fields
   - Related list of invoice items
   - Images of the invoice
6. End of flow

### Alternative Flows

##### 1. The administrator selects an Invoice which status is Pending belonging to a Program that does not consider invoice items (step 3 of basic flow)
   1. The administrator selects a Program that does not consider invoice items
   2. The administrator selects one of the Invoices of the selected Program, which status is Pending
   3. The system displays the Invoice details page, containing:
       - Edit button
       - Approve button
       - Reject button
       - Fieldset of Invoice fields
       - Images of the invoice
   4. End of flow
   
##### 2. The administrator selects an Invoice which status is Approved belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is Approved
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Revert button
        - Review button
        - Fieldset of Invoice fields
        - Related list of invoice items
        - Images of the invoice
    3. End of flow
 
##### 3. The administrator selects an Invoice which status is Approved belonging to a Program that does not consider Invoice Items (step 2 of alternative flow 1)
   1. The administrator selects one of the Invoices of the selected Program, which status is Approved
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Revert button
        - Review button
        - Fieldset of Invoice fields
        - Images of the invoice
   3. End of flow
   
##### 4. The administrator selects an Invoice which status is Rejected belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is Rejected
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Review button
        - Fieldset of Invoice fields
        - Related list of invoice items
        - Images of the invoice
   3. End of flow
   
##### 5. The administrator selects an Invoice which status is Rejected belonging to a Program that does not consider Invoice Items (step 2 of alternative flow 1)
   1. The administrator selects one of the Invoices of the selected Program, which status is Rejected
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Review button
        - Fieldset of Invoice fields
        - Images of the invoice
   3. End of flow
   
##### 6. The administrator selects an Invoice which status is Reverted belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is Reverted
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Review button
        - Fieldset of Invoice fields
        - Related list of invoice items
        - Images of the invoice
   3. End of flow
   
##### 7. The administrator selects an Invoice which status is Reverted belonging to a Program that does not consider Invoice Items (step 2 of alternative flow 1)
   1. The administrator selects one of the Invoices of the selected Program, which status is Reverted
   2. The system displays the Invoice details page, containing:
        - Edit button
        - Review button
        - Fieldset of Invoice fields
        - Images of the invoice
   3. End of flow
   
##### 8. The administrator presses the Approve button of a Pending Invoice (step 5 of basic flow and step 3 of alternative flow 1)
   1. The administrator presses the Approve button
   2. The system calls the basic flow of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
    
##### 9. The administrator presses the Reject button of a Pending Invoice (step 5 of basic flow and step 3 of alternative flow 1)
   1. The administrator presses the Reject button
   2. The system calls the alternative flow 1 of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
   
##### 10. The administrator presses the Revert button of an Approved Invoice (step 2 of alternative flow 2 and step 2 of alternative flow 3)
   1. The administrator presses the Revert button
   2. The system calls the alternative flow 2 of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
   
##### 11. The administrator presses the Review button of an Approved Invoice (step 2 of alternative flow 2 and step 2 of alternative flow 3)
   1. The administrator presses the Review button
   2. The system calls the alternative flow 3 of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
    
##### 12. The administrator presses the Review button of a Rejected Invoice (step 2 of alternative flow 4 and step 2 of alternative flow 5)
   1. The administrator presses the Review button
   2. The system calls the alternative flow 4 of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
   
##### 13. The administrator presses the Review button of a Reverted Invoice (step 2 of alternative flow 6 and step 2 of alternative flow 7)
   1. The administrator presses the Review button
   2. The system calls the alternative flow 5 of use case [Change Invoice Status](?name=UC-PRP-0004)
   3. End of flow
   
##### 14. The administrator presses the Edit Button (step 5 of basic flow, step 3 of alternative flow 1 and step 2 of alternative flows 3 to 7)
   1. The system displays the Invoice Edit form with all its information already loaded
   2. End of flow  
