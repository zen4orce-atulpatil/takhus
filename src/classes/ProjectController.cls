/*Description : This class is used as a controller class for Projects VF page. Purpose of this class is to get, set and manipulate
Projects data
Created By : Mustafa
Created Date : November 2016*/
public class ProjectController {
    public String productName{get;set;}
    public Project__c pro {get;set;}
    public Opportunity opp{get;set;}
    public String productId {get;set;}
    public String projectId {get;set;}
    public String selectedUser{get;set;}
    public Boolean isRenderTabs{get;set;}
    public Boolean isreRenderProject{get;set;}
    public Boolean isreRenderView{get;set;}
    public String loggedInUserId{get;set;}
    public boolean isRerenderRnD{get;set;}
    public boolean isRerenderSC{get;set;}
    public boolean isRenderQaQc{get;set;}
    public boolean isRerenderSHE{get;set;}
    public Boolean isRerenderRegulatory{get;set;}
    public boolean isRenderMfg{get;set;}
    public boolean isRenderWh{get;set;}
   
    public List<ProcessInstanceWorkItem> workItemList;
    public static Map<Id, Project__c> projectMap = new Map<Id,Project__c>();
    public User usr{get;set;}
    //procurement
    public Boolean isRerenderProc{get;set;}
    public Product__c prod{get;set;}
    //costing
    public boolean isRenderCosting{get;set;}
    
    public ProjectController(){
        opp = new Opportunity(); 
        loggedInUserId = UserInfo.getUserId();
        usr =[Select Department From User where Id=:loggedInUserId limit 1];
     }
    
    /*Description : Purpose of this method is to get all the project details*/
    public List<Project__c> getfetchProjects(){
        try{
            for(Project__c pr : TurboPLMSelector.getAllProjects()){
                projectMap.put(pr.Id, pr);
            }
            List<Project__c> pr = new List<Project__c>();
            pr = projectMap.values();
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       	}
    	return projectMap.values();
    }
    
    /*Description : Purpose of this method is to show the project details.
    It opens the isreRenderView panel to display details of particular project
 	*/
    public void viewProjectDetails(){
        try{
            if(projectId != null && projectId != '' && projectMap.get(projectId)!=null){
                pro = projectMap.get(projectId);
            }
            else{
                pro=new Project__c();
            }
            isreRenderView = true;
            isreRenderProject=false;
            isRerenderRnD = false;
            isRerenderSC=false;
            isRerenderProc=false;
            isRerenderRegulatory=false;
            isRenderQaQc = false;
            isRerenderSHE = false;
            isRenderCosting=false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
	/*Description : Purpose of this method is to edit the project details.
    It opens the isreRenderProject panel to edit the details of particular project*/
  
    public void editProjectDetails(){
        try{
            CreateProjectController.reset = true;
            if(projectId !=null){
               pro = projectMap.get(projectId);
            }
            isreRenderProject=true;
            isreRenderView=false;
            isRerenderRnD = false;
            isRerenderSC=false;
            isRerenderProc=false;
            isRerenderRegulatory=false;
            isRenderQaQc = false;
            isRerenderSHE = false;
            isRenderCosting=false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
    /*Description : Purpose of this method is on click of continue button it opens 
    the Rnd Questions for NPI panel.*/
    public void displayRndQuestions(){
        isreRenderProject=false;
        isreRenderView=false;
        isRerenderRnD = true;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderCosting=false;
    }
    
    /*Description : Purpose of this method is reject the project.
    once it is rejected it goes to the marketing department for reasign or final rejection*/
    public void rejectProject(){
        try{
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(opp.Approve_Reject_Comment__c);
            req.setAction('Reject');
            Id workItemId = getWorkItemId(pro.Id); 
            if(workItemId == null){
            }
            else{
                req.setWorkitemId(workItemId);
                Approval.ProcessResult result =  Approval.process(req);
            }
            pro.Department__c = 'Marketing';
            pro.Approval_Status__c = 'Rejected';
            ProjectDomain.updateProject(pro);
            isreRenderView = false;
            isreRenderProject = false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
    //Description : Purpose of this method is get all the users whoes department is same as logged in user department.
    public List<SelectOption> getUsers(){
		List<SelectOption> lstUsers = new List<SelectOption>();
        try{
            List<User> lstUersOfSameDept = TurboPLMSelector.getUsersOfSameDept(usr.Department);
            lstUsers.add(new SelectOption('0','Select'));
            for(User usr:lstUersOfSameDept ){
                lstUsers.add(new SelectOption(usr.Id,usr.Name));  
            }
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
       return lstUsers;
    }
    
    //Description : Purpose of this method is get the pending approval processes for user.
    public String getProcessInstance(){
        try{
            workItemList = TurboPLMSelector.getProcessInstanceWorkItemRecord(String.valueOf(pro.Id));   
            ProcessInstanceWorkItem ProcessInstance = workItemList.get(0);
            return String.valueOf(ProcessInstance.ActorId);
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
           return null;
       }    
    }
    
    //Description : Purpose of this method is reassign the project to other user.
    public void reassignProject(){
        try{
            System.debug('selectedUser'+selectedUser);
            getProcessInstance();
            workItemList.get(0).ActorId = selectedUser;
            ProjectDomain.updateWorkItemList(workItemList);
             System.debug('workItemList'+workItemList);
            Product__share shareProduct = new Product__share();
            shareProduct.ParentId  = String.valueOf(pro.Product__c); 
            shareProduct.UserOrGroupId = selectedUser;
            shareProduct.AccessLevel = 'Edit'; 
            if(selectedUser != pro.CreatedById){
                ProjectDomain.insertSharedRecord(shareProduct);            
            }
            isreRenderView = false;
            isreRenderProject = false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
	//Description : Purpose of this method is get the user’s pending approval request.
    public Id getWorkItemId(Id targetObjectId){
        try{
            Id retVal = null;
            for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                where p.ProcessInstance.TargetObjectId =: targetObjectId]){
                retVal  =  workItem.Id;
            }
            return retVal;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
           return null;
       }            
    }
    
    //Description : Purpose of this method is close all the open panels
    public void closeAllOpenPanels(){
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=false;
    }
    
    //Description : Purpose of this method is close all the open panels and refresh table
    public void closeAllAndRerenderTable(){
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=false; 
    }
        //Description : Purpose of this method is open supply chain component for create and edit project.
    public void createEditSCProject(){
        try{
        if(projectId !=null)
            {
               pro = projectMap.get(projectId);
            }
            isreRenderProject= false;
            isRerenderRnD= false;
            isreRenderView= false;
            isRerenderProc=false;
            isRerenderRegulatory=false;
            isRerenderSC=true;
            isRenderQaQc = false;
            isRerenderSHE = false;
            isRenderMfg = false;
        	isRenderWh = false;
            isRenderCosting=false; 
        }catch(Exception e){
             System.debug('ERROR'+e.getMessage()); 
        }
    }
    //Description:- Purpose of this method id to set variables for displaying Procurement component and set selected project and product record
    public void viewProcurementProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
        }
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderRegulatory=false;
        isRerenderProc=true;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=false; 
    }
    
    //Description:- Purpose of this method id to set variables for displaying RegulatoryClearance component and set selected project and product record	
    public void viewRegulatoryClearanceProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        }
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=true;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false; 
        isRenderCosting=false; 
    }
    
    //Description:- Purpose of this method id to set variables for displaying QaQcSpecification component and set selected project and product record.	
    public void viewQaQcSpecificationProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        }
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = true;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=false; 
    }
   
    //Description:- Purpose of this method id to set variables for displaying SHE component and set selected project and product record.	
    public void viewSHEProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        } 
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = true;
       	isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=false; 
    }
    
	//Description:- Purpose of this method id to set variables for displaying MFG component and set selected project and product record.	
    public void viewMFGProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        } 
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = true;
        isRenderWh = false;
        isRenderCosting=false; 
    }    
    
    //Description:- Purpose of this method id to set variables for displaying Warehouse component and set selected project and product record.	
    public void viewWHProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        } 
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = true;
        isRenderCosting=false; 
    }
    //Description:- Purpose of this method id to set variables for displaying costing component and set selected project and product record.	
    public void viewCostingProject(){
        if(productId != null){
           prod = TurboPLMSelector.getProductRecord(productId);
            
        } 
        if(projectId !=null){
               pro = projectMap.get(projectId);
        }
        isreRenderProject= false;
        isRerenderRnD= false;
        isreRenderView= false;
        isRerenderSC=false;
        isRerenderProc=false;
        isRerenderRegulatory=false;
        isRenderQaQc = false;
        isRerenderSHE = false;
        isRenderMfg = false;
        isRenderWh = false;
        isRenderCosting=true; 
    }
}