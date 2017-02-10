/*
Description : This class is used as a helper class for test classes.
opportunity data
Created By : Mustafa 
Created Date : November 2016
*/
public class TestClassHelper {
    
    //Description:- Create number of opportunity records provided in count.
    public static List<Opportunity> CreateOpportunity(Integer count){
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(Integer i=0;i<count;i++){
            Opportunity opp = new Opportunity();
    		opp.Name = 'Sample Opportunity '+i;
    		opp.Customer_Name__c = 'James Bond';
    		opp.Amount = 50000;
    		Opp.CloseDate = Date.today().addDays(30);
    		opp.Description = 'Sample Description';
            opp.StageName = 'Prospecting';
    		lstOpportunity.add(opp);
        }
        insert lstOpportunity;
        return lstOpportunity;
    }
    
    //Description:- Create number of Account records provided in count.
    public static List<Account> CreateAccount(Integer count){
        List<Account> lstAccounts = new List<Account>();
        for(Integer i=0;i<count;i++){
            Account acc= new Account();
            acc.Name = 'Sample Account '+i;
            lstAccounts.add(acc);    
        }
        insert lstAccounts;
        return lstAccounts;
    }
    
    //Description:- Create number of product records specified in count parameter.
    public static List<Product__c> createProduct(Integer count){
        List<Product__c> lstProduct = new List<Product__c>();
        for(Integer i=0;i<count;i++){
			Product__c product = new Product__c();
            product.Name = 'Sample Product';
            product.Tradename__c = 'Some Trade';
            product.Project_Type__c = 'NPI';            
            lstProduct.add(product);
        }
        Insert lstProduct;  
        return lstProduct;
    }
    
    //Description:- Create number of project records specified in count parameter
    public static List<Project__c> createProject(List<Product__c> lstProduct){
        List<Project__c> lstProject = new List<Project__c>();
        for(Product__c varProduct : lstProduct){
            Project__c project = new Project__c();
            project.Status__c = 'Active';
            project.Approval_Status__c = 'Not Submitted';
            project.Department__c = 'Marketing';	
            project.Product__c = varProduct.Id;
            lstProject.add(project);
        }
        Insert lstProject; 
        return lstProject;
    }
    
    //Description:- Create user records
    public static void createUsers(Integer count, String dept){
        List<User> lsrusr = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        //for(Integer i=0;i<count;i++){
        	User u = new User(Alias = 'tstUser', Email='mustafa.jhabuawala1@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'RND', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa1@zen4orce.com');    
        
        	User u1 = new User(Alias = 'tstUser', Email='mustafa.jhabuawala2@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'RND', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa2@zen4orce.com');    
        
            lsrusr.add(u);
        //}
        Insert lsrusr;
    }
}