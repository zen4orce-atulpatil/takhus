/*Description : This class is used as a controller class for OpportunitySales VF page. Purpose of this class is to get, set and manipulate
opportunity data
Created By : Mustafa 
Created Date : November 2016*/
public class OpportunitySalesController 
{
 	public Boolean viewOpportunity{get;set;}
 	public Boolean oppNewEdit{get;set;}
  	public static Map<Id, Opportunity> opportunityMap = new Map<Id,Opportunity>();
    public String notificationMessage{get;set;}
    public String notificationType{get;set;}
   	public String oppId{get; set;}
    public Opportunity opp{get;set;}
    public User usr{get;set;}
    public String loggedInUserId{get;set;}
    
    public OpportunitySalesController(){
       
        loggedInUserId = UserInfo.getUserId();
        usr =[Select Department From User where Id=:loggedInUserId limit 1];
     }
    /*Description : Purpose of this method is to get all the Opportunities details
    to display into the datatable*/
    public List<Opportunity> getfetchOpportunities(){
       try{
           for(Opportunity op : TurboPLMSelector.getAllOpportunitiesForSales()){
               opportunityMap.put(op.Id, op);                               
           }
           List<Opportunity> op = new List<Opportunity>();
           op = opportunityMap.values();
       }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       }            
       return opportunityMap.values();
    }
   
   	/*Description : Purpose of this method is open the CreateOpportunity wizard
   	to create new opportunity*/
    public void createNewOpportunity(){
        try{
           
            opp = new Opportunity();
            oppId= null;
            
            viewOpportunity = false;
            oppNewEdit = true;
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       }
    }
    
    /*Description : Purpose of this method is open the CreateOpportunity wizard
   	to Edit existing opportunity*/
    public void editOpportunity(){
        viewOpportunity = false;
        oppNewEdit = true;
        try{
            if(oppId != null && opportunityMap.containskey(oppId)){
                opp = opportunityMap.get(oppId);
            }
            else{
                opp = new Opportunity();
            }
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       	}            
     }
     
    /*Description : Purpose of this method is open the ViewOpportunity panel
   	to show selected opportunity*/
    public void viewOpportunityData(){
        viewOpportunity = true;
        oppNewEdit = false;
        try{
            if(oppId != null && opportunityMap.containskey(oppId)){
                opp = opportunityMap.get(oppId);
            }
            else{
                opp = new Opportunity();
            }
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
    /*Description : Purpose of this method is delete the selected opportunity*/
    public void deleteOpportunity(){
        opp = new Opportunity();
       	viewOpportunity = false;
        oppNewEdit = false;
        try{
            if(oppId !=null && opportunityMap.containskey(oppId)){
                if(CreateEditOpportunityDomain.deleteOpportunity(opportunityMap.get(oppId))){
                    notificationMessage = Label.DeleteMessage;
                	notificationType = 'success';
                }
                //17-2-2017
                /*else{
                    notificationMessage = Label.FailureMessage;
                	notificationType = 'error';    
                }*/
            }
            opportunityMap.remove(oppId);
            oppId = null;
        }catch(Exception e){
          notificationType = 'error';   
          notificationMessage = Label.FailureMessage;  
          System.debug('ERROR'+e.getMessage()); 
       }            
    }
    
    /*Description : Purpose of this method is close all the panels*/
    public void closeAllPanel(){
        try{
            oppNewEdit= false;
            viewOpportunity= false;
        }catch(Exception e){
          System.debug('ERROR'+e.getMessage()); 
       	}            
    }
}