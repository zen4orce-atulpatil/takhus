public class OppMarketingController {
 	//Properties
    public Opportunity opp{get;set;}
    public String selectedOppId{get;set;}
    public String buttonAction{get;set;}
    public String oppAction {get;set;}
    public Boolean rendereViewOppPanel{get;set;}
    public Boolean renderSelectProject{get;set;}
    public list<SelectOption> projectTypeOptionList{get;set;}
    public String selectedProjectType {get;set;}
    public Boolean renderCreateProjectPanel{get;set;}
    public String userAction{get;set;}
    public Map<Id, Opportunity> opportunityMap = new Map<Id,Opportunity>();
    public User usr{get;set;}
    public String loggedInUserId{get;set;}
    

    //Description : Purpose of this method is to get all the opportunities details
    public List<Opportunity> getfetchOpportunities() {
        try{
            if(opportunityMap.isEmpty()) {	
                    for(Opportunity op : TurboPLMSelector.getAllOpportunitiesForMarketing()) {
                        opportunityMap.put(op.Id, op);                               
                    }
            }
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }            
        return opportunityMap.values();
    }
    
    //Constructor
    public OppMarketingController() {
        try{
            projectTypeOptionList = new list<SelectOption>();
            projectTypeOptionList.add(new SelectOption('Select','---Select---'));
            Schema.DescribeFieldResult fieldResult = Product__c.Project_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
                projectTypeOptionList.add(new SelectOption(f.getLabel(), f.getValue()));
            } 
            loggedInUserId = UserInfo.getUserId();
        	usr =[Select Department From User where Id=:loggedInUserId limit 1];
        }catch(Exception e){
            System.debug('ERROR'+e.getMessage()); 
        }            
    }
    
    //Description : Purpose of this method is to display selected opportunity details
    public void viewOppportunity() {
        selectedProjectType='';
        try{
            if(selectedOppId != null && selectedOppId != '' && opportunityMap.get(selectedOppId) != null) {
                opp = opportunityMap.get(selectedOppId);
            } else {
                opp = new Opportunity();
            }
            if('ViewOpp'.equalsIgnoreCase(userAction)) {
                rendereViewOppPanel = true;
                renderSelectProject = false;
                renderCreateProjectPanel = false;
            }else {
                renderSelectProject = true;
                rendereViewOppPanel = false;
                renderCreateProjectPanel = false;
            }
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       }
    }
    
    //Description : Purpose of this method is to open the create project panel
    public void viewCreateProjectPanel() {
        if(selectedProjectType == 'NPI'){
			renderCreateProjectPanel = true;  
            rendereViewOppPanel = false;
        }
        else{
        	renderCreateProjectPanel = false; 
            rendereViewOppPanel = false;
        }
    }
    
    //Description : Purpose of this method is to update the approval status of project and add comment
    public void udateComments() {
        try{
        if(opp != null && opp.id != null && buttonAction != null && buttonAction != '' && oppAction != null && oppAction != '') {
            CreateEditOpportunityDomain.updateOpportunity(opp, buttonAction);
        }
        rendereViewOppPanel = false;
        renderSelectProject = 'savecreate'.equalsIgnoreCase(oppAction) ? true : false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }     
    }
    
        //Description : Purpose of this method is close all open panel
    public void closeAllPanel() {
        try{
            renderCreateProjectPanel = false;  
            rendereViewOppPanel = false;
            renderSelectProject=false;
        }catch(Exception e){
           System.debug('ERROR'+e.getMessage()); 
       }     
    }
}