## Create an Invoice Item

### Objectives 
This use case describes the creation of an Invoice Item

### Preconditions
The option to Consider Invoice Detail in the Member’s Program is set to true  
The administrator must be logged in

### Postconditions
An Invoice Item is created

### Flow of Events

### Basic Flow

1. The system receives the information for the Invoice items
2. The system creates an Invoice Item with some of its fields filled up with the received information
3. The system analyzes the following fields of each Invoice Item: Quantity, Unit Price and Total Price
4. The system checks that the Unit Price and Quantity fields were received
5. The system calculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
6. The system fills the Total Price field with the value calculated in the previous step
7. The system saves the Invoice Item
8. Enf of flow


### Alternative Flows

##### 1. The received fields are Total Price and Quantity (step 4 of the basic flow)
   1. The system checks that the Total Price and Quantity fields were received
   2. The system calculates the value of Unit Price field by dividing the value in the Total Price field by the value in the Quantity field.
   3. The system fills the Unit Price field with the value calculated in the previous step.
   4. End of flow

##### 2. The received fields are Unit Price and Total Price (step 4 of the basic flow)
   1. The system checks that the Total Price and Unit Price fields were received
   2. The system calculates the value of Quantity field by dividing the value in the Total Price field by the value in the Unit Price field.
   3. The system fills the Quantity field with the value calculated in the previous step.
   4. End of flow
   
##### 3. All three fields were received (step 4 of the basic flow)
   1. The system receives values for all three fields (Unit price, Quantity and Total price)
   2. The system calculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field.
   3. The system ignores the received Total Price and fills the Total Price field with the value calculated in the previous step.
   4. End of flow

##### 4. Only the Total Price field is received (step 4 of the basic flow)
   1. The system receives only the value of the Total Price field
   2. The system fills the Total Price field with the received value
   3. End of flow
   
##### 5. Only the Quantity field is received (step 4 of the basic flow)
   1. The system receives only the value for Quantity field
   2. The system fills the Unit Price field with 0 (zero)
   3. The system calculates the value of Total Price field by multiplying the value in the Quantity field by 0 (zero)
   4. The system fills the Total Price field with the value calculated in the previous step
   5. End of flow
   
#### 6. Only the Unit Price field is received (step 4 of the basic flow)
   1. The system receives only the value for Unit Price field
   2. The system displays an error message
   3. End of flow
   
##### 7. None of the fields are received (step 4 of the basic flow)
   1. The system does not receive any value for the fields Quantity, Unit Price and Total Price
   2. The system displays an error message
   3. End of flow
   
##### 8. The received Quantity value is invalid (step 4 of the basic flow)
   1. The system verifies that the Quantity field is filled with 0 (zero) or with a negative value
   2. The system displays an error message
   3. End of flow
   
##### 9. The administrator edits the Total Price field (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Total Price field
   3. The system does not recalculate the Total Price
   4. The system maintains the edited value in the Total Price field
   5. End of flow
   
##### 10. The administrator edits the Quantity field (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Quantity field 
   3. The system recalculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
   4. The system updates the Total Price field with the calculated value
   5. End of flow
   
##### 11. The administrator edits Quantity and Total Price fields (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Quantity and Total Price fields
   3. The system recalculates the value of Unit Price field by dividing the value in the Total Price field by the value in the Quantity field.
   4. The system updates the Unit Price field with the calculated value
   5. End of flow
   
##### 12. The administrator edits the Unit Price field (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Unit Price field
   3. The system recalculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
   4. The system updates the Total Price field with the calculated value
   5. End of flow
   
##### 13. The administrator edits the Unit Price and Total Price fields (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Unit Price and the Total Price fields
   3. The system recalculates the value of Quantity field by dividing the value in the Total Price field by the value in the Unit Price field.
   4. The system updates the Quantity field with the calculated value
   5. End of flow
   
##### 14. The administrator edits the Unit Price and Quantity fields (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is Pending
   2. The administrator edits the Unit Price and the Quantity fields
   3. The system recalculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
   4. The system updates the Total Price field with the calculated value
   5. End of flow
   
##### 15. The administrator edits the Unit Price, Quantity and Total Price fields (step 3 of the basic flow)
   1. The system verifies that the status of the related Invoice is set to Pending
   2. The administrator edits the Unit Price, Quantity and Total Price fields
   3. The system recalculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
   4. The system updates the Total Price field with the calculated value
   5. End of flow

##### 16. The administrator tries to edit the Invoice Item that is related to an Invoice not in status Pending (step 7 of the basic flow)
   1. The system verifies that the status of the related Invoice is different from Pending
   2. The administrator presses the Edit button in the detail view of the Invoice Item
   3. The system displays an error message
   4. End of flow
   
##### 17. The administrator tries to edit the Invoice Item with an invalid value for the Quantity field (step 7 of the basic flow)
   1. The system verifies that the Quantity field is updated with 0 (zero) or with a negative value
   2. The system displays an error message
   3. End of flow

##### 18. The administrator deletes an Invoice Item (step 7 of the basic flow)
   1. The administrator selects the option to Delete the Invoice Item
   2. The system verifies that the status of the related Invoice is Pending
   3. The system delets the invoice item
   4. The system updates the Amount field of the related Invoice with the summarize of the Total Price field of its remaining related Invoice Items
   5. End of flow
   
##### 19. The administrator tries to edit the Invoice Lookup (step 7 of the basic flow)
   1. The system verifies that the status of the related Invoice is set to Pending
   2. The administrator tries to edit the Invoice Lookup field
   4. The system displays an error message
   5.	End of flow
