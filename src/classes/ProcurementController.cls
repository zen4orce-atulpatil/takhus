/*Description : Purpose of this Class id to Handle Save and Edit Operation of Procurement question component.
Created By : Mustafa
Created Date : November 2016*/
public class ProcurementController {

    public Product__c productRecord{get;set;}
    public boolean rawMaterial{get;set;}
    public boolean erpData{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public String selectedUser{get;set;}
	public Project__c projectRecord{get;set;} 
    
    //Description : purpose of this method is save the Procurement product.
    public void saveProduct(){
        try{
            if(ProcurementDomain.saveProcurementProduct(productRecord,rawMaterial,erpData)){
               notificationType = 'success';
               notificationMessage = Label.SaveMessage; 
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
    }
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
        List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('Regulatory Clearance');
           	lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstUsers;
    } 
    
    //Description : purpose of this method is save the Procurement product and submit project to next approval.
    public void submitProcurementDetailsForApproval(){
        try{
            //1.save
            saveProduct();
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
                    //3. update the Project Status and Department 
                    ProcurementDomain.submitProjectToRegulatoryClearance(projectRecord);
                    //4.share record
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
}