@isTest
public class HeatMapControllerTest{
    @testSetup static void setup() {
        Account acc = new Account(Name = 'TestAccount');
        Insert acc;
        Contact con = new Contact(LastName = 'TestData', Salutation = 'Mr.', LeadSource = 'Web', AccountId = acc.Id);
        Insert con;
    }
    
    @isTest
    static void testHeatMapService(){
        HeatMapService hm = new HeatMapService(null);
        System.assertNotEquals(null, hm.getValues());
        System.assertEquals(null, hm.getDefaultValue());
    }
    
    @isTest
    static void testgetPicklistFields(){
        List<HeatMapService.PicklistWrapper> plWrapper = HeatMapController.getPicklistFields('Contact');
        System.assert(!plWrapper.isEmpty());
    }
    
    @isTest
    static void testgetHeatMap(){
        List<Account> accs = [SELECT Id from Account];
        System.assertNotEquals(null, HeatMapController.getHeatMap('Contact', 'LeadSource', 'Salutation', 'AccountId', accs[0].Id));
    }

}