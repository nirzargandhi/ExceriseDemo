//
//  BreakTimeVC.swift
//  ExceriseDemo
//
//  Created by Nirzar Gandhi on 03/09/21.
//

class BreakTimeVC: UIViewController {
    //MARK: - UILabel Outlet
    @IBOutlet weak var lblExerciseName: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    
    //MARK: - Variable Declaration
    var timer = Timer()
    var intTimerCount = 20
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblTimer.text = "00:20"
        
        self.perform(#selector(self.startTimer), with: nil, afterDelay: 1.0)
    }
    
    //MARK: - Initialization Method
    func initialization() {
        hideNavigationBar(isTabbar: false)
    }
    
    //MARK: - Start Timer Method
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkTimer), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    //MARK: - Check Timer Method
    @objc func checkTimer() {
        if intTimerCount > 0 {
            intTimerCount -= 1
            
            lblTimer.text = timeString(time: TimeInterval(intTimerCount))
        } else {
            timer.invalidate()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Time String Method
    func timeString(time:TimeInterval) -> String {
        _ = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
