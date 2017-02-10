/*Description : Purpose of this Class id to Handle Save and Edit Operation of QA_QC_Specification component.
Created By : Mustafa
Created Date : November 2016*/
public class QA_QC_SpecificationController {
    
    public Project__c projectRecord{get;set;}
    public String selectedUser{get;set;}
    public List<SelectOption> testMethodsSOList;
    public List<PmQaSpec> pmQaSpecList;
    public List<SelectOption> soPmQaSpecList;
    public map<id,QA_Spec__c> mapQaSpec = new map<id,QA_Spec__c>();
    public boolean flagForError{get;set;}
    public String notificationType{get;set;}
    public String notificationMessage{get;set;}
    
    //Description:- Purpose of this method is to return Select option list of Test_Method__c Records.
    public List<SelectOption> getTestMethods(){
        try{
            if(testMethodsSOList == null){
                testMethodsSOList = new List<SelectOption>();
                List<Test_Method__c> lstTestMethods = new List<Test_Method__c>([select Id,Name from Test_Method__c]);
                testMethodsSOList.add(new SelectOption('Select','---Select---'));
                for(Test_Method__c varTestMethod : lstTestMethods){
                    testMethodsSOList.add(new SelectOption(varTestMethod.Id,varTestMethod.Name));    
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return testMethodsSOList;
    }
    
    //Description:- Purpose of this method id to return Select option List of QA_Spec__c records.
    private List<SelectOption> getSoPmQaList(){
        try{
            if(soPmQaSpecList == null){
                List<QA_Spec__c> localQaList = new list<QA_Spec__c>();
                soPmQaSpecList = new List<SelectOption>();
                soPmQaSpecList .add(new SelectOption('Select','--Select--'));
                localQaList = TurboPLMSelector.getAllQaSpecs();
                if(!localQaList.isEmpty()){
                    for(QA_Spec__c p :localQaList) {
                        soPmQaSpecList.add(new SelectOption(p.id,p.Name));
                        mapQaSpec.put(p.id,p);
                    }
                }
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return soPmQaSpecList;    
    }
    
    //Description:-Purpose of this method is to return wrapper List of PmQaSpec
    public List<PmQaSpec> getpmQas(){
         try{
             if(pmQaSpecList == null){
                 soPmQaSpecList=getSoPmQaList();
                 pmQaSpecList = new List<PmQaSpec>();
                 List<PM_QA_Spec__c> lstPmQaSpec = new List<PM_QA_Spec__c>();
                 lstPmQaSpec = TurboPLMSelector.getPmQaQcSpecsByProductId(projectRecord.Product__c);
                 if(lstPmQaSpec.size()>0){
                     for(PM_QA_Spec__c varPmQaSpec : lstPmQaSpec){
                         String selectedParam = String.valueOf(varPmQaSpec.QA_Spec__r.Id);
                         pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList,selectedParam,varPmQaSpec.Range__c,varPmQaSpec.UOM__c,varPmQaSpec ,varPmQaSpec.Test_Method__c));
                     } 
                 } 
                 else{
                     pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null, null,null,new PM_QA_Spec__c(),null));                
                 }              
             }else{
                 List<PmQaSpec> tempPmQasList = new List<PmQaSpec>();
                 Integer count = 0;
                 for(PmQaSpec varPmQaSpec : pmQaSpecList){
                     if(varPmQaSpec.isRemove == false){
                         count++;
                     }
                 }
                 if(count == 0){
                     tempPmQasList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null, null,null,new PM_QA_Spec__c(),null));
                 }
                 pmQaSpecList.addAll(tempPmQasList);
             }
         }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
        return pmQaSpecList;
    }
    
    //Description:- Purpose of this method is to blank row for addning new record. 
    public void addAnotherPmQa(){
         try{
             if(pmQaSpecList != null){
                 pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null,null, null,new PM_QA_Spec__c(),null));
             }
             else{
                 pmQaSpecList = new List<PmQaSpec>();
                 soPmQaSpecList=getSoPmQaList();
                 pmQaSpecList.add(new PmQaSpec(mapQaSpec,soPmQaSpecList, null,null, null,new PM_QA_Spec__c(),null));
             }
         }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
        }
    }
    
    //Description:- This method returns Select option list of users.
    public List<SelectOption> getUsers(){
		List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept('SHE');
            lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
        	System.debug('ERROR='+e.getMessage());    
        }    
        return lstUsers;
    }
    
    //Description:- Purpose of this method is to save the details specified.
    public void SaveQASpecDetails(){
    	flagForError = true;
        boolean selectedAll = true;
        List<PmQaSpec> tempPmQasList = new List<PmQaSpec>();
        try{
            list<PM_QA_Spec__c> pmQaToUpsert = new list<PM_QA_Spec__c>();
            list<PM_QA_Spec__c> pmQaToDelete = new list<PM_QA_Spec__c>();
            for(PmQaSpec b:pmQaSpecList){
                if(b.isRemove==false){ 
                    tempPmQasList.add(b);
                    if(b.pmQaSpecRef!=null &&!b.selectedParam.equalsIgnoreCase('Select') && !b.selectedTestMethod.equalsIgnoreCase('Select')){
                        b.pmQaSpecRef.QA_Spec__c =  b.selectedParam;
                        b.pmQaSpecRef.Range__c = b.range;
                        b.pmQaSpecRef.Test_Method__c = b.selectedTestMethod;
                        if( b.pmQaSpecRef.Product__c==null){
                            b.pmQaSpecRef.Product__c = projectRecord.Product__c;
                        }
                        pmQaToUpsert.add(b.pmQaSpecRef);     
                    }else{
                        selectedAll = false;
                        notificationType = 'error';
                        notificationMessage = 'Please Select QA/QC Specification and Test Method';
                    	//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select QA/Qc Specification and Test Method'));	    
                    }
                }
                else{
                    if(b.pmQaSpecRef.Id!=null){
                        pmQaToDelete.add(b.pmQaSpecRef);            	
                    }	
                }
            }
            pmQaSpecList.clear();
            pmQaSpecList.addAll(tempPmQasList);
            if(selectedAll){
                if(QA_QC_SpecificationDomain.upsertQaQcSpecification(pmQaToUpsert)){
                    notificationType = 'success';
                    notificationMessage = Label.SaveMessage;    
                }    
            }
            pmQaToUpsert = null;
            if(QA_QC_SpecificationDomain.deleteQaQcSpecification(pmQaToDelete)){
            }
            pmQaToDelete = null;
        }catch(Exception e){
            flagForError = false;
            System.debug('ERROR='+e.getMessage());
            notificationType = 'error';
            notificationMessage = Label.FailureMessage;
        }    
    }
    
    //Description:- Purpose of this method is to save changes and submit to next department.
    public void saveAndSubmitQaQcSpecDetails(){
    	 try{
            //1.save
            SaveQASpecDetails();
            if(flagForError == true){
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
                        QA_QC_SpecificationDomain.submitProjectToSHE(projectRecord);
                        
                        Product__share shareProduct = new Product__share();
                        shareProduct.ParentId  = String.valueOf(projectRecord.Product__c); 
                        shareProduct.UserOrGroupId = selectedUser;
                        shareProduct.AccessLevel = 'Edit'; 
                        
                        if(selectedUser != projectRecord.CreatedById){
                            QA_QC_SpecificationDomain.insertSharedRecord(shareProduct);            
                		}
                    }else{
                    	notificationType = 'error';
                		notificationMessage = Label.FailureMessage;    
                    }
                } 
            }
        }catch(Exception e){
            System.debug('ERROR='+e.getMessage());
            notificationType = 'error';
            notificationMessage = Label.FailureMessage;
        }
    }
    
    //Purpose of this method is to get ProcessInstanceWorkitem record for given object.
    public Id getWorkItemId(Id targetObjectId){
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
    
    public void resetComponent(){
    	projectRecord = null;
        pmQaSpecList = null;  
        selectedUser = null;
        notificationType = null;
        notificationMessage = null;
        flagForError = null;
    }
}