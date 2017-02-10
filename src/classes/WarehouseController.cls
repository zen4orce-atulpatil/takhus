/*
Description : This class is used as a controller class for Warehouse component.
Projects data
Created By : Mustafa (Zen4orce)
Created Date : November 2016
*/
public class WarehouseController {
    public Product__c productRecord{get;set;}
    public Project__c projectRecord{get;set;}
    public boolean allWhFunctions{get;set;}
    public boolean whERP{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public String selectedUser{get;set;}
    
	//Description:- purpose of this method is to update product record.
    public void saveWHProduct(){
        try{
        if(WarehouseDomain.saveWHProduct(productRecord,allWhFunctions,whERP)){
            notificationType = 'success';
            notificationMessage = Label.SaveMessage; 
        }else{
            notificationType = 'error';
            notificationMessage = Label.FailureMessage; 
        }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
    }
    
     //Description:- purpose of this method is to submit project record to warehouse department
    public void submitWHDetailsForApproval(){
        try{
            //1.save
            	saveWHProduct();
                //2.send the Project for Approval, 
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Approving request');
                req.setAction('Approve');
                req.setNextApproverIds(new Id[] {selectedUser});//  Selection of next Approver, 
                Id workItemId = getWorkItemId(projectRecord.id); 
                if(workItemId == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Approval_Process_Initiated_Error));
                }
                else{
                    req.setWorkitemId(workItemId);
                    // Submit the request for approval
                    Approval.ProcessResult result =  Approval.process(req);
                    if(result.isSuccess()){
                        notificationType = 'success';
                		notificationMessage = Label.SubmitMessage;
                        
                        WarehouseDomain.submitProjectToCosting(projectRecord);
                        
                        Product__share shareProduct = new Product__share();
                        shareProduct.ParentId  = String.valueOf(projectRecord.Product__c); 
                        shareProduct.UserOrGroupId = selectedUser;
                        shareProduct.AccessLevel = 'Edit'; 
                        
                        if(selectedUser != projectRecord.CreatedById){
                            ProjectDomain.insertSharedRecord(shareProduct);            
                        }
                    }else{
                    	notificationType = 'error';
                		notificationMessage = Label.FailureMessage;    
                    }
                } 
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    //Purpose of this method is to get ProcessInstanceWorkitem record for given object.
    public Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;
        try{
            for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                where p.ProcessInstance.TargetObjectId =: targetObjectId])
            {
                retVal  =  workItem.Id;
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return retVal;
    }
    
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
        List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('Costing');
           	lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstUsers;
    } 
}