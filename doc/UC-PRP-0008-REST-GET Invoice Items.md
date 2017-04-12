## GET Invoice Items

### Objectives
Obtain the invoice items list of a particular Invoice

### Preconditions

### Postconditions
The system returns a JSON structure with the invoice items list of a particular invoice

### Flow of Events

### Basic Flow
1. The user makes a GET request for the resource /members/member_id/invoices/invoice_id/invoiceitems
2. The system validates that the user of the request has permission to access the records
3. The system verifies that the request has no additional parameters
4. The system returns the Invoice Items list with the default fieldset
5. End of flow

### Alternative Flows

##### 1. The user of the request has no permission to access the records (step 2 of basic flow)
   1. The system generates a reply with status code 403 containing the error code and its corresponding message
   2. End of flow
   
##### 2. The invoice does not have related items (step 4 of basic flow)
   1. The system generates a reply with status code 200 without elements in its content
   2. End of flow
   
##### 3. The user of the request provided additional parameters in the request (step 3 of basic flow)
   1. The system generates a reply with status code 200 containing the invoice items list of the invoice and considering the following additional parameters:
        - fields
        - limit
        - offset
        - orderby
   2. End of flow
