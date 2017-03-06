## Invoice Roll up calculations

### Objectives
This use case describes the calculations that need to be done after the upload of the invoice and its related invoice items

### Preconditions
The checkbox "Consider Invoice Detail" of the Invoice related program is set to trueThe checkbox "Consider Invoice Detail" of the Invoice related program is set to true

### Postconditions
The respective field of the Invoice Item is calculated considering the other two fields

### Flow of Events

### Basic Flow

1. The system analyzes the following fields of each Invoice Item: Quantity, Unit Price and Total Price
2. The system checks that the Unit Price and Quantity fields are filled
3. The system calculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field
4. The system updates the Total Price field with the value calculated in the previous step
5. End of flow

### Alternative Flows

##### 1. The filled fields are Total Price and Quantity (step 2 of the basic flow)
   1. The system checks that the Total Price and Quantity fields are filled
   2. The system calculates the value of Unit Price field by dividing the value in the Total Price field by the value in the Quantity field.
   3. The system updates the Unit Price field with the value calculated in the previous step.    
   4. Back to step 5 of basic flow

##### 2. The filled fields are Unit Price and Total Price (step 2 of the basic flow)
   1. The system checks that the Total Price and Unit Price fields are filled
   2. The system calculates the value of Quantity field by dividing the value in the Total Price field by the value in the Unit Price field.
   3. The system updates the Quantity field with the value calculated in the previous step.
   4. Back to step 5 of basic flow

##### 3. All three fiels are filled (step 2 of the basic flow)
   1. The system receives values for all three fields (Unit price, Quantity and Total price)
   2. The system calculates the value of Total Price field by multiplying the value in the Unit Price field by the value in the Quantity field.
   3. The system updates the Total Price field with the value calculated in the previous step.
   4. Back to step 1 of the basic flow

##### 4. Only the Total Price field is filled (step 2 of the basic flow)
   1. The system receives only the value of the Total Price field
   2. The system updates the Total Price field with the value received
   3. Back to step 1 of the basic flow

##### 5. Only the Quantity field or the Unit Price field is filled (step 2 of the basic flow)
   1. The system receives only the value of one field Unit Price or Quantity
   2. The system displays the corresponding error message
   3. Back to step 1 of the basic flow

##### 6. None of the fields are filled (step 2 of the basic flow)
   1. The system does not receive any value for the fields Quantity, Unit Price and Total Price
   2. The system displays the corresponding error message
   3. Back to step 1 of the basic flow

##### 7. The field Quantity is filled with an invalid value (step 1 of the basic flow)
   1. The system verifies that the Quantity field is filled with 0 (zero) or a negative value
   2. The system displays the corresponding error message
   3. Back to step 1 of the basic flow
