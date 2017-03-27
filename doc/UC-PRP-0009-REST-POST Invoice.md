## POST Invoice

### Objectives
Create an invoice with its related items for a specific member

### Preconditions

### Postconditions
The system creates an invoice and all its related items for a particular member

### Flow of Events

### Basic Flow
1. The user makes a POST request for the resource /members/member_id/invoices, containing the following required parameters in its body:  
         - Invoice header
         - Invoice Items
2. The system validates that the user of the request has permission to write records
3. The system identifies the member from the the resource URI 
4. The system calls the use case [Create an Invoice](?name=UC-PRP-0002)
5. The system generates a reply with status code 201 containing the invoice and its related items information
6. End of flow

### Alternative Flows

##### 1. The user of the request has no permission to write records (step 2 of basic flow)
   1. The system generates a reply with status code 403 containing the error code and its corresponding message
   2. End of flow
