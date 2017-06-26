## Create an Invoice

### Objectives 
This use case describes the creation of an Invoice

### Preconditions
The administrator must be logged in

### Postconditions
An Invoice is created

### Flow of Events

### Basic Flow

1. The system receives the information for the invoice and for the invoice items 
2. The system verifies that Member field is not null
3. The system verifies that the option "Request Invoice Products" of the related member's program is set to true
4. The system verifies that Date field is not null
5. The system verifies that there is no other invoice with the same combination number (Distributor Id + Invoice Number) in status Approved.
6. The system sets the status "Open" for the Invoice
7. The system saves the Invoice
8. The system calls the use case [Create an Invoice Item](https://github.com/FieloIncentiveAutomation/fieloprp/blob/develop/doc/UC-PRP-0001-Create%20an%20Invoice%20Item.md)
9. The system updates the Amount field ot the invoice with the summarize of the Total Price field of the related Invoice Items 
10. The system saves the Invoice
11. End of flow

### Alternative flows

##### 1. The option "Consider Invoice Detail" is set to false (step 1 of the basic flow)
   1. The system verifies that the option "Consider Invoice Detail" of the related member's program is set to false
   2. The system receives the information for the Invoice
   3. The system creates an Invoice with its fields filled up with the received information
   4. The system sets the Status of the Invoice to Draft
   5. The system fills the Amount field with the received value 
   6. End of flow

##### 2. The administrator deletes the invoice (step 7 of the basic flow)
   1. The administrator selects the option to Delete the Invoice
   2. The system deletes the invoice and all its related Invoice items
   3. End of flow

##### 3. The administrator tries to edit the Amount field when the option "Consider Invoice Detail" is true (step 6 of the basic flow)
   1. The administrator tries to edit the Amount field
   2. The system verifies that the option "Consider Invoice Detail" is set to true
   3. The system displays an error message
   4. End of flow
   
##### 4. The administrator tries to create an Invoice with no member (step 3 of the basic flow)
   1. The administrator tries to save the Invoice without filling the Member field
   2. The system displays an error message
   3. End of flow

##### 5. The administrator tries to edit the Member Lookup (step 7 of the basic flow)
   1. The system verifies that the status of the Invoice is set to Draft
   2. The administrator tries to edit the Member Lookup field
   4. The system displays an error message
   5. End of flow

##### 6. The administrator tries to edit the Invoice when its status is not Draft (step 7 of the basic flow)
   1. The system verifies that the status of the Invoice is not Draft
   2. The administrator tries to edit the Invoice
   4. The system displays an error message
   5. End of flow
