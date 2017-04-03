## Display Invoice Details Page

### Objectives
The present use case describes how the system shows the Invoice details and the action buttons for each invoice status

### Preconditions
- There must be Invoices created for Programs that consider invoice items and for Programs that do not consider invoice items
- There must be Invoices in all status (Draft, Pending, Approved, Rejected and Canceled) for each Program
- The administrator must be logged in

### Postconditions
- The system displayed the details of the selected Invoice
- The system displayed the corresponding action buttons for each Invoice Status

### Flow of Events

### Basic Flow
1. The administrator presses the Invoices tab
2. The system shows the Invoices landing page
3. The administrator selects a Program that considers invoice items
4. The administrator selects one of the Invoices of the selected Program, which status is “Draft”
5. The system displays the Invoice details page, containing:
   - Edit button
   - Approve button
   - Submit for Approval button
   - Fieldset for the Invoice
   - Related list of invoice items
   - Images of the invoice
   - Approval process steps
6. End of flow

### Alternative Flows

##### 1. The administrator selects an Invoice which status is “Draft” belonging to a Program that does not consider invoice items (step 3 of basic flow)
   1. The administrator selects a Program that does not consider invoice items
   2. The administrator selects one of the Invoices of the selected Program, which status is “Draft”
   3. The system displays the Invoice details page, containing:
      - Edit button
      - Approve button
      - Submit for Approval button
      - Fieldset for Invoice
      - Images of the invoice
      - Approval process steps
   4. End of flow

##### 2. The administrator selects an Invoice which status is “Pending” belonging to a Program that considers invoice items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is "Pending"
   2. The system displays the Invoice details page, containing:
      - Approve button
      - Reject button
      - Reopen button
      - Fieldset for Invoice
      - Related list of invoice items
      - Images of the invoice
      - Approval process steps
   3. End of flow

##### 3. The administrator selects an Invoice which status is "Pending" belonging to a Program that does not consider invoice items (step 3 of basic flow)
   1. The administrator selects a Program that does not consider invoice items
   2. The administrator selects one of the Invoices of the selected Program, which status is "Pending"
   3. The system displays the Invoice details page, containing:
       - Approve button
       - Reject button
       - Reopen button
       - Fieldset for Invoice
       - Images of the invoice
       - Approval process steps
   4. End of flow
   
##### 4. The administrator selects an Invoice which status is "Approved" belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is "Approved"
   2. The system displays the Invoice details page, containing:
        - Reprocess  button
        - Cancel button
        - Fieldset for Invoice
        - Related list of invoice items
        - Images of the invoice
        - Approval process steps
    3. End of flow
 
##### 5. The administrator selects an Invoice which status is "Approved" belonging to a Program that does not consider Invoice Items (step 3 of basic flow)
   1. The administrator selects a Program that does not consider invoice items
   2. The administrator selects one of the Invoices of the selected Program, which status is "Approved"
   3. The system displays the Invoice details page, containing:
        - Reprocess button
        - Cancel button
        - Fieldset for Invoice
        - Images of the invoice
        - Approval process steps
   4. End of flow
   
##### 6. The administrator selects an Invoice which status is "Rejected" belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is "Rejected"
   2. The system displays the Invoice details page, containing:
        - Reopen button
        - Fieldset for Invoice
        - Related list of invoice items
        - Images of the invoice
        - Approval process steps
   3. End of flow
   
##### 7. The administrator selects an Invoice which status is "Rejected" belonging to a Program that does not consider Invoice Items (step 3 of basic flow)
   1. The administrator selects a Program that does not consider invoice items
   2. The administrator selects one of the Invoices of the selected Program, which status is "Rejected"
   3. The system displays the Invoice details page, containing:
        - Reopen button
        - Fieldset for Invoice
        - Images of the invoice
        - Approval process steps
   4. End of flow
   
##### 8. The administrator selects an Invoice which status is "Canceled" belonging to a Program that considers Invoice Items (step 4 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is "Canceled"
   2. The system displays the Invoice details page, containing:
        - Reprocess button
        - Reopen button
        - Fieldset for Invoice
        - Related list of invoice items
        - Images of the invoice
        - Approval process steps
   3. End of flow
   
##### 9. The administrator selects an Invoice which status is "Canceled" belonging to a Program that does not consider Invoice Items (step 3 of basic flow)
   1. The administrator selects one of the Invoices of the selected Program, which status is "Canceled"
   2. The system displays the Invoice details page, containing:
        - Reprocess button
        - Reopen button
        - Fieldset for Invoice
        - Images of the invoice
        - Approval process steps
   3. End of flow
