//
//  GetReadyVC.swift
//  ExceriseDemo
//
//  Created by Nirzar Gandhi on 03/09/21.
//

class GetReadyVC: UIViewController {
    
    //MARK: - UILabel Outlet
    @IBOutlet weak var lblTimer: UILabel!
    
    //MARK: - Variable Declaration
    var timer = Timer()
    var intTimerCount = 3
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            
            lblTimer.text = "\(intTimerCount)"
        } else {
            timer.invalidate()
            
            let objExerciseVC = AllStoryBoard.Main.instantiateViewController(withIdentifier: ViewControllerName.kExerciseVC) as! ExerciseVC
            self.navigationController?.pushViewController(objExerciseVC, animated: true)
        }
    }
}
