/*Description : This class is used as a controller class for Regulatory clearance VF page. Purpose of this class is to get, set and manipulate
Regulatory clearance  data
Created By : Mustafa
Created Date : November 2016 */
public class RegulatoryClearanceController {

    public map<id,Chem_Regulation__c> mapOfChemRegulations = new map<id,Chem_Regulation__c>();
    public List<RegulatoryClearanceWrapper> rcWrapperList;
    public List<SelectOption> soRegulatoryList;
   // public String productID{get;set;}
    public Product__c productRecord{get;set;}
    public Project__c projectRecord{get;set;}
    public boolean reset{get;set;}
    public boolean resetFlag;
    public boolean flagForError{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    public String selectedUser{get;set;}
    
   	public RegulatoryClearanceController(){
        resetFlag = true;
    }
    /*Description : Purpose of this method is to reset component when selecting another project in project page.*/
    public void resetComponent(){
      	reset = false;
        rcWrapperList = null;
       
    }
    /*Description : Purpose of this method is to prepare a list of type SelectOption for User object
	whoes department is same as logged in user department.*/
    public List<SelectOption> getUsers(){
         List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('QA/QC');
           	lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }    
        return lstUsers;
    }
    //Description : Purpose of this method is return SelectOption List to regulatory clearance.
     public List<SelectOption> getChemRegulationDetails(){
        List<SelectOption> chemRegulatoryList = new List<SelectOption>();
        try{
            List<Chem_Regulation__c> chemRegulatoryRecordsList =[SELECT Id,Name FROM Chem_Regulation__c];
            chemRegulatoryList.add(new SelectOption('Select','--Select--'));
            for(Chem_Regulation__c chem:chemRegulatoryRecordsList ){
                chemRegulatoryList.add(new SelectOption(chem.Id, chem.Name)); 
                mapOfChemRegulations.put(chem.Id, chem);
            }
        }catch(Exception e){
         	System.debug('ERROR='+e.getMessage());
        }
        return chemRegulatoryList;
    }
    //Description : Purpose of this method is to add another row in regulatory list.
    public void addRegClearanceWrapperObj(){
        try{
               if(rcWrapperList == null){
                    rcWrapperList = new List<RegulatoryClearanceWrapper>();
                    soRegulatoryList=getChemRegulationDetails();
                }
            	rcWrapperList.add(new RegulatoryClearanceWrapper(soRegulatoryList,null,mapOfChemRegulations,new PM_Regulatory_Clearance__c()));
        	}catch(Exception e){
        		System.debug('ERROR='+e.getMessage());    
        	}
       }
    //Description : getter method of regulatory clearance.
    public List<RegulatoryClearanceWrapper> getRegulatoryClearance(){
        if(rcWrapperList == null){
            soRegulatoryList=getChemRegulationDetails();
                List<PM_Regulatory_Clearance__c > lstRegulatory = new List<PM_Regulatory_Clearance__c>();
                lstRegulatory = turboPLMSelector.getPmRegulatoryClearance(productRecord.Id);
                if(lstRegulatory.size()>0){
                    rcWrapperList = new List<RegulatoryClearanceWrapper>();
                    for(PM_Regulatory_Clearance__c varReg: lstRegulatory){
                        String selectedRegulatory = String.valueOf(varReg.Regulatory_List__c);
                        rcWrapperList.add(new RegulatoryClearanceWrapper(soRegulatoryList,selectedRegulatory,mapOfChemRegulations,varReg)); 
                         
                        }
                }else{
                        rcWrapperList = new List<RegulatoryClearanceWrapper>();
                        rcWrapperList.add(new RegulatoryClearanceWrapper(soRegulatoryList,null,mapOfChemRegulations,new PM_Regulatory_Clearance__c()));
                }
            
        }else{
                Integer count = 0;
                List<RegulatoryClearanceWrapper> tempRcLstPlant = new List<RegulatoryClearanceWrapper>();
                for(RegulatoryClearanceWrapper rc: rcWrapperList){
                    if(rc.isRemoveRegulatory == false){
                        count++;
                    }
                }
                if(count==0){
                    tempRcLstPlant.add(new RegulatoryClearanceWrapper(soRegulatoryList,null,mapOfChemRegulations,new PM_Regulatory_Clearance__c()));
                }
            	rcWrapperList.addAll(tempRcLstPlant);
        	}
        return rcWrapperList;
    }
    //Description : Purpose of this method is save regulatory clearance details and product.
    public void saveRegulatoryClearanceDetails(){
        //upsert regulatory
        System.debug('rcWrapperList--->'+rcWrapperList);
         try{
             
             flagForError = true;
             boolean isSuccess = true;
             List<PM_Regulatory_Clearance__c> regulatoryToUpsert = new List<PM_Regulatory_Clearance__c>();
             List<PM_Regulatory_Clearance__c> regulatoryToDelete = new List<PM_Regulatory_Clearance__c>();
             for(RegulatoryClearanceWrapper rw:rcWrapperList){
                 System.debug('********************** rw.selRegulatoryClearance -' + rw.selRegulatoryClearance);
                 if(rw.isRemoveRegulatory==false){
                     
                     if(rw.selRegulatoryClearance != null){
                         if(rw.selRegulatoryClearance !=null && !rw.selRegulatoryClearance.equalsIgnoreCase('Select')){
                             if(rw.regulatoryClearanceRef.Project__c==null){
                             rw.regulatoryClearanceRef.Project__c= productRecord.Id;
                         		}
                         rw.regulatoryClearanceRef.Regulatory_List__c = rw.selRegulatoryClearance;
                         regulatoryToUpsert.add(rw.regulatoryClearanceRef);
                         }
                         else{
                             flagForError = false;//check whether this will be replaced by notificationtype variable
                             notificationType = '';
                             notificationMessage = '';
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'please select regulatory clearance'));
                     	}
                     }
                 }else{
                     if(rw.regulatoryClearanceRef.Id!=null){
                         regulatoryToDelete.add(rw.regulatoryClearanceRef);          	
                     }
                 }
                 
             }
             if(flagForError == true){
                 //14-2-2017
                 /*if(!RegulatoryClearanceDomain.updateRegulatoryClearanceProduct(productRecord)){
				isSuccess = false; 
				}*/
                 if(!RegulatoryClearanceDomain.upsertRegulatoryClearance(regulatoryToUpsert)){
                     isSuccess = false;
                 }
                 regulatoryToUpsert = null;
                 
                 //for(RegulatoryClearanceWrapper rw:rcWrapperList){
                 RegulatoryClearanceDomain.deleteRegulatoryClearance(regulatoryToDelete);
                 regulatoryToDelete=null;	 
                 if(isSuccess){
                     notificationType = 'success';
                     notificationMessage = Label.SaveMessage;
                 }else{
                     notificationType = 'warning';
                     notificationMessage = Label.PartialSaveMessageRnD;
                 }
             }
         }catch(Exception e){
            flagForError = false;
            notificationType = '';
            notificationMessage = '';
            System.debug('Exception===>'+e);
            System.debug('Line Number--->'+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
        }     
    } 
    //Description :Purpose of this method is save regulatory clearance details and product and send it to next department for approval.
    public void submitRCDetailsForApproval(){
        boolean isSuccess = true;
        saveRegulatoryClearanceDetails();
        if(flagForError ==true){
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
                       	isSuccess = true;
                       // notificationType = 'success';
                		//notificationMessage = Label.SubmitMessage;
                    }else{
                        isSuccess = false;
                    	//notificationType = 'error';
                		//notificationMessage = Label.FailureMessage;    
                    }
                } 
                //3. update the Project Status and Department 
            	if(!RegulatoryClearanceDomain.submitProjectToQAQC(projectRecord)){
                	isSuccess = false; 
            	}
                //4.share record
                Product__share shareProduct = new Product__share();
                shareProduct.ParentId  = String.valueOf(projectRecord.Product__c); 
                shareProduct.UserOrGroupId = selectedUser;
                shareProduct.AccessLevel = 'Edit'; 
                
                if(selectedUser != projectRecord.CreatedById){
                    ProjectDomain.insertSharedRecord(shareProduct);            
                }
            if(isSuccess){
                notificationType = 'success';
                notificationMessage = Label.SubmitMessage;
            }else{
                notificationType = 'error';
                notificationMessage = Label.FailureMessage; 
            }
        }
    }
    //Description:Purpose of this method is to get ProcessInstanceWorkitem record for given object.
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
     /*****************Wrapper Classes***************************/
    //Description : Wrapper class for Regulatory clearance object.
    public class RegulatoryClearanceWrapper {
        public List<SelectOption> ChemRegulationDetails{get;set;}
        public Boolean isRemoveRegulatory{get;set;}
        public String selRegulatoryClearance{get;set;}
        public map<id,Chem_Regulation__c> wrapperMapOfChemReulatory = new map<id,Chem_Regulation__c>();
        public PM_Regulatory_Clearance__c regulatoryClearanceRef {get;set;}
        
        public RegulatoryClearanceWrapper(List<SelectOption> chemRegulatoryList,
                                          String selRegClearance,
                                          map<id,Chem_Regulation__c> mapOfChemRegulations,
                                          PM_Regulatory_Clearance__c regulatoryClearanceRef
                                         ){
            this.ChemRegulationDetails = chemRegulatoryList;
            this.selRegulatoryClearance = selRegClearance;
            this.wrapperMapOfChemReulatory = mapOfChemRegulations;
            this.regulatoryClearanceRef = regulatoryClearanceRef;
            this.isRemoveRegulatory = false;
        }
        
        //Descritpiotn:- Purpose of this class is to set flag for removig Regulatory Clearance Record.
        public void removeRegulatoryRecord(){
            if(isRemoveRegulatory == false){
                this.isRemoveRegulatory = true;
            }
    	}
    }
}