import Foundation

class CancelableTask {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var completion: (() -> ())?
    
    init() { /* EMPTY */ }
    
    func start(timeInterval: DispatchTimeInterval, completion: @escaping (() -> ())) {
        self.completion = completion
        let pendingRequestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if self.pendingRequestWorkItem?.isCancelled == false { self.completion?() }
        }
        
        self.pendingRequestWorkItem = pendingRequestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval,
                                      execute: pendingRequestWorkItem)
    }
    
    func cancel() {
        pendingRequestWorkItem?.cancel()
    }
    
}
