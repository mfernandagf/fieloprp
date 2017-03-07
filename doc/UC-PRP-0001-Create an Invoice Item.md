## Create an Invoice Item

### Objectives 
This use case describes the creation of an Invoice Item

### Preconditions
The administrator must be logged in

### Postconditions
An Invoice Item is created

### Flow of Events

### Basic Flow

1. The system receives the information for the Invoice items
2. The system creates an Invoice Item with some of its fields filled up with the received information
   - Invoice
   - Product
   - Quantity
   - Unit Price
   - Total Price
3. The system analyzes the following fields of each Invoice Item: Quantity, Unit Price and Total Price
4. The system checks that the Unit Price and Quantity fields were received
5. The system calculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
6. The system fills the Total Price field with the value calculated in the previous step
7. Enf of flow


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
   
##### 9. The administrator edits the fields Unit Price, Quantity or Total Price of the invoice item (step 2 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is set to Draft
   2. The administrator edits one or more of the following fields: Unit Price, Quantity or Total Price
   3. The administrator presses the Save button
   4. Back to step 3 of the basic flow

##### 10. The administrator tries to edit the Invoice Item that is related to an Invoice not anymore in status Draft (step 2 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is different from Draft
   2. The administrator presses the Edit button in the detail view of the Invoice Item
   3. The system displays an error message
   4. End of flow

##### 11. The administrator deletes an Invoice Item (step 2 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is set to Draft
   2. The administrator presses the Delete button in the detail view of the Invoice Item
   3. The system updates Amount field of the corresponding Invoice with the summarize of the Total Price field of its the related Invoice Items
   4. End of flow
   
##### 12. The administrator tries to delete an Invoice Item that is related to an Invoice not anymore in status Draft (step 2 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is different from Draft
   2. The administrator presses the Delete button in the detail view of the Invoice Item
   3. The system displays an error message
   4. End of flow

##### 13. The administrator tries to edit the Invoice Lookup (step 2 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is set to Draft
   2. The administrator presses the Edit button in the detail view of the Invoice Item 
   3. The administrator tries to edit the Invoice Lookup field
   4. The system displays an error message
   5.	End of flow
