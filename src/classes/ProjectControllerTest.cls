@isTest
public class ProjectControllerTest {
	
    @testSetup
    public static void testData(){
		List<Product__c> lstProduct = TestClassHelper.createProduct(10);
        List<Project__c> lstProject = TestClassHelper.createProject(lstProduct);
        List<User> lsrusr = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'tstUser', Email='mustafa.jhabuawala1@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'Rnd', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa1@zen4orce.com');    
        
        User u1 = new User(Alias = 'tsttUser', Email='mustafa.jhabuawala2@zen4orce.com', 
            EmailEncodingKey='UTF-8', LastName='TestUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,Department = 'Rnd', 
            TimeZoneSidKey='America/Los_Angeles', UserName='jhabuawala.mustafa2@zen4orce.com');    
        lsrusr.add(u);
        lsrusr.add(u1);
        Insert lsrusr;
    }
    
    @isTest
    public static void testGetfetchProjects(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProject = PC.getfetchProjects();
        Integer prjCount = [select count() from Project__c];
        System.assertEquals(prjCount,lstProject.size());
    }
    
    @isTest
    public static void testViewProjectDetailswithValue(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProject = PC.getfetchProjects();
        PC.projectId = String.valueOf(lstProject[0].Id);
        PC.viewProjectDetails();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.pro.Id!=null);
    }
    
    @isTest
    public static void testViewProjectDetailswithoutValue(){
    	ProjectController PC = new ProjectController();
        PC.viewProjectDetails();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.pro.Id==null);
    }
    
    @isTest
    public static void testEditProjectDetailsWithValue(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProject = PC.getfetchProjects();
        PC.projectId = String.valueOf(lstProject[0].Id);  
        PC.editProjectDetails();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.pro.Id!=null);
    }
    
    @isTest
    public static void testEditProjectDetailsWithoutValue(){
        ProjectController PC = new ProjectController();
        PC.editProjectDetails();
        System.assertEquals(true,PC.pro==null);
    }
    
    @isTest
    public static void testDisplayRnDQuestions(){
        ProjectController PC = new ProjectController();
        PC.displayRndQuestions();
        System.assertEquals(true, PC.isRerenderRnD);
        System.assertEquals(false, PC.isreRenderProject);
        System.assertEquals(false, PC.isreRenderView);
        System.assertEquals(false, PC.isRerenderSC);
        System.assertEquals(false, PC.isRerenderProc);
        System.assertEquals(false, PC.isRerenderRegulatory);
        System.assertEquals(false, PC.isRenderQaQc);
    }
                            
	@isTest
    public static void testRejectProjectWithValue(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval');
        req.setObjectId(lstProjects[0].Id);
        User u = [select Id from user where email=:'mustafa.jhabuawala1@zen4orce.com'];
        req.setNextApproverIds(new Id[] {u.Id});
        Approval.ProcessResult result = Approval.process(req);
        
        PC.pro = lstProjects[0];
        PC.rejectProject();
    }
    
    @isTest
    public static void testRejectProjectWithoutValue(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        PC.pro = lstProjects[0];
        PC.rejectProject();
    }
    
    @isTest
    public static void testGetUsers(){
    	ProjectController PC = new ProjectController();
        PC.usr = [Select Id, Name, Department from User where email=:'mustafa.jhabuawala1@zen4orce.com'];
        System.debug('PC.usr-->'+PC.usr);
        List<SelectOption> usersSOList = PC.getUsers();
        
        Integer userCount = [select count() from user where Department =: 'Rnd'];
        System.assertEquals(userCount,usersSOList.size()-1);//-1 is for removing count of default select value.
    }
    
    @isTest
    public static void testReassignProject(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval');
        req.setObjectId(lstProjects[0].Id);
        User u = [select Id from user where email=:'mustafa.jhabuawala1@zen4orce.com'] ;
        req.setNextApproverIds(new Id[] {u.Id});
        Approval.ProcessResult result = Approval.process(req);  
        
        PC.pro = lstProjects[0];
        PC.selectedUser = String.valueOf([select id from user where email=:'mustafa.jhabuawala2@zen4orce.com'].Id);
		PC.reassignProject();        
    }
    
    @isTest
    public static void testCloseAllOpenPanels(){
    	ProjectController PC = new ProjectController();
        pc.closeAllOpenPanels();
        System.assertEquals(false, PC.isreRenderProject);
        System.assertEquals(false, PC.isRerenderRnD);
        System.assertEquals(false, PC.isreRenderView);
        System.assertEquals(false, PC.isRerenderSC);
        System.assertEquals(false, PC.isRerenderProc);
        System.assertEquals(false, PC.isRerenderRegulatory);
        System.assertEquals(false, PC.isRenderQaQc);
    }
    
    @isTest
    public static void testCloseAllAndRerenderTable(){
    	ProjectController PC = new ProjectController();
        pc.closeAllAndRerenderTable();
        System.assertEquals(false, PC.isreRenderProject);
        System.assertEquals(false, PC.isRerenderRnD);
        System.assertEquals(false, PC.isreRenderView);
        System.assertEquals(false, PC.isRerenderSC);
        System.assertEquals(false, PC.isRerenderProc);
        System.assertEquals(false, PC.isRerenderRegulatory);
        System.assertEquals(false, PC.isRenderQaQc);    
    }
    
    @isTest
    public static void testcreateEditSCProject(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[0].Id;
        PC.createEditSCProject();
        System.assertEquals(lstProjects[0].Id,PC.pro.Id);
        System.assertEquals(true,PC.isRerenderSC);
    }
    
    @isTest
    public static void testViewProcurementProject(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;
        PC.viewProcurementProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true,PC.isRerenderProc);
    }
    
	@isTest
    public static void testViewRegulatoryClearanceProject(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;
        PC.viewRegulatoryClearanceProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true,PC.isRerenderRegulatory);
    }
    
    @isTest
    public static void testviewQaQcSpecificationProject(){
    	ProjectController PC = new ProjectController();
        List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;
        PC.viewQaQcSpecificationProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true,PC.isRenderQaQc);    
    }
    
    @isTest
    public static void testViewSHEProject(){
        ProjectController PC = new ProjectController();
    	List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;    
        PC.viewSHEProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true, PC.isRerenderSHE);
    }
    
    @isTest
    public static void testViewMFGProject(){
        ProjectController PC = new ProjectController();
    	List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;    
        PC.viewMFGProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true, PC.isRenderMfg);    
    }
    
    @isTest
    public static void testViewWHProject(){
    	ProjectController PC = new ProjectController();
    	List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;    
        PC.viewWHProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true, PC.isRenderWh);    
    }
    
    @isTest
    public static void testViewCostingProject(){
    	ProjectController PC = new ProjectController();
    	List<Project__c> lstProjects = PC.getfetchProjects();
        PC.projectId = lstProjects[1].Id;
        PC.productId = lstProjects[1].Product__c;    
        PC.viewCostingProject();
        System.assertEquals(true,PC.pro!=null);
        System.assertEquals(true,PC.prod!=null);
        System.assertEquals(true, PC.isRenderCosting);    
    }
}