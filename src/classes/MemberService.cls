public class MemberService {
    public static Boolean isMemberBlocked(String memberId){
        List<FieloPLT__Member__c> members = new MembersSelector( new Set<String>{'FieloPLT__Status__c'} ).selectbyId(new Set<Id>{memberId});
        if(!members.isEmpty())
            return members.get(0).FieloPLT__Status__c == 'Blocked' ? true : false;
        else
            return false;
    }
}