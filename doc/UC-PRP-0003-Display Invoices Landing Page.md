## Display Invoices Landing Page

### Objectives
The present use case describes the display of the Invoices landing page

### Preconditions
The administrator must be logged in

### Postconditions
Invoices for the selected Program and View were displayed

### Flow of Events

### Basic Flow
1. The administrator accesses the Invoices tab 
2. The system shows the Invoices landing page containing the following items:
   - Current View
   - Picklist for Programs
   - Options for selection of the desired View (Recent Invoices or All Invoices)
   - New button
   - Invoices list
3. The system shows as the default view, when page loads, the list of the Recent Invoices
4. The system shows in the picklist for Programs all the existing Programs for selection
5. The systems shows for the Invoice list the columns Name, Member, Status and Amount 	
6. End of flow

### Alternative Flows

##### 1. The administrator changes the view (step 3 of the basic flow)
   1. The administrator selects each of the Invoices view
   2. The system shows the list of Invoices according to the selected view
   3. The systems changes the current view info on the top to the selected view
   4. End of flow 
   
##### 2. There is only one Program available (step 4 of the basic flow)
   1. The system does not show the picklist for Program selection
   2. End of flow
   
##### 3. The administrator changes the Program (step 4 of the basic flow)
   1. The administrator changes the Program in the picklist
   2. The system shows the list of the Invoices of the selected Program
   3. End of flow
   
##### 4. The administrator selects an Invoice of the list (step 5 of the basic flow)
   1. The administrator selects an Invoice
   2. The system shows the Invoice detail page
   3. End of flow
