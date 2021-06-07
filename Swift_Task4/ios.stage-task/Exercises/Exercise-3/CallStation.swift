import Foundation

final class CallStation {
    var userList = Set<User>()
    var callList = [CallID: Call]()
    var currentCallList  = [CallID: Call]()
    
    
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CallStation: Station {


    func users() -> [User] {
        return Array(userList)
    }
    
    func add(user: User) {
        userList.insert(user)
    }
    
    func remove(user: User) {
        userList.remove(user)
        if let call = currentCall(user: user) {
            let theCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
            currentCallList[call.incomingUser.id] = nil
            currentCallList[call.outgoingUser.id] = nil
            callList[call.id] = theCall
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from: fromUser, to: toUser):
            if userList.contains(fromUser) {
                if !userList.contains(toUser){
                    let call = Call(id: CallID(), incomingUser: toUser, outgoingUser: fromUser, status: .ended(reason: .error))
                    callList[call.id] = call
                    return call.id
                }
                if currentCall(user: fromUser) != nil || currentCall(user: toUser) != nil {
                    let call = Call(id: CallID(), incomingUser: toUser, outgoingUser: fromUser, status: .ended(reason: .userBusy))
                    callList[call.id] = call
                    return call.id
                }
                
                let call = Call(id: CallID(), incomingUser: toUser, outgoingUser: fromUser, status: .calling)
                callList[call.id] = call
                currentCallList[fromUser.id] = call
                currentCallList[toUser.id] = call
                return call.id
                
            }
        case let .answer(from: user):
            
 
            if let call = currentCallList[user.id], call.status == .calling, call.incomingUser == user {
                let curCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
                callList[call.id] = curCall
                currentCallList[call.incomingUser.id] = curCall
                currentCallList[call.outgoingUser.id] = curCall
                return curCall.id
            }
        case let .end(from: user):
            if let call = currentCallList[user.id] {
                currentCallList[call.incomingUser.id] = nil
                currentCallList[call.outgoingUser.id] = nil
                let status: CallStatus = call.status == .talk ? .ended(reason: .end): .ended(reason: .cancel)
                let currCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: status)
                callList[call.id] = currCall
                return currCall.id
            }
        }
        return nil
    }
    
    func calls() -> [Call] {
        return Array(callList.values)
    }
    
    func calls(user: User) -> [Call] {
        return calls().filter {
            $0.incomingUser == user || $0.outgoingUser == user
        }
    }
    
    func call(id: CallID) -> Call? {
        return callList[id]
    }
    
    func currentCall(user: User) -> Call? {
        return currentCallList[user.id]
    }
}
