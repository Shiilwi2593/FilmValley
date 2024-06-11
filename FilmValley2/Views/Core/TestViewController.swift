//import UIKit
//import FirebaseDatabase
//import Firebase
//
//class TestViewController: UIViewController {
//    
//    var dataArr: [String] = []
//    var chartData: [(rating: Int, count: Int)] = [
//        (1, 0),
//        (2, 0),
//        (3, 0),
//        (4, 0),
//        (5, 0),
//        (6, 0),
//        (7, 0),
//        (8, 0),
//        (9, 0),
//        (10, 0)
//    ]
//    
//    private lazy var rateAvgBtn: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        var config = UIButton.Configuration.filled()
//        let image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
//        config.image = image
//        config.imagePlacement = .leading
//        config.baseBackgroundColor = UIColor(red: 0.259, green: 0.722, blue: 0.878, alpha: 1)
//        config.subtitle = "View statistical"
//        
//        let title = AttributedString("0.0", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]))
//        config.attributedTitle = title
//        config.baseForegroundColor = .white
//        config.imagePadding = 5
//        
//        button.configuration = config
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        // Thêm nút vào view sau khi đã được thiết lập
//        view.addSubview(rateAvgBtn)
//        rateAvgBtn.addTarget(self, action: #selector(rateAvgBtnTapped), for: .touchUpInside)
//        
//        // Thiết lập constraints cho nút
//        NSLayoutConstraint.activate([
//            rateAvgBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            rateAvgBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            rateAvgBtn.heightAnchor.constraint(equalToConstant: 60),
//            rateAvgBtn.widthAnchor.constraint(equalToConstant: 150)
//        ])
//        
//        // Lấy dữ liệu từ Firebase
//        getData { data in
//            self.dataArr = data
//            self.getPoint(data: self.dataArr) { points in
//                let sum = points.reduce(0, +)
//                let average = sum / Double(points.count)
//                let formattedAvg = String(format: "%.1f", average)
//                let title = AttributedString("\(formattedAvg)/10", attributes: AttributeContainer([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16, weight: .bold)]))
//                self.rateAvgBtn.configuration?.attributedTitle = title
//                print(self.chartData)
//            }
//        }
//    }
//    
//    private func getData(completion: @escaping ([String]) -> Void) {
//        let ref = Database.database().reference().child("Film").child("F01").child("reviews")
//        
//        ref.observeSingleEvent(of: .value) { snapshot in
//            if let data = snapshot.value as? [String] {
//                completion(data)
//            } else {
//                completion([])
//            }
//        }
//    }
//    
//    private func getPoint(data: [String], completion: @escaping ([Double]) -> Void) {
//        var points: [Double] = []
//        let ref = Database.database().reference().child("Reviews")
//        let group = DispatchGroup()
//        
//        for index in data {
//            group.enter()
//            let tempRef = ref.child(index).child("ratePoint")
//            tempRef.observeSingleEvent(of: .value) { snapshot in
//                if let data = snapshot.value as? Double {
//                    points.append(data)
//                    if let rating = Int(exactly: data), rating >= 1, rating <= 10 {
//                        if let i = self.chartData.firstIndex(where: { $0.rating == rating }) {
//                            self.chartData[i].count += 1
//                        }
//                    }
//                }
//                group.leave()
//            }
//        }
//        
//        group.notify(queue: .main) {
//            completion(points)
//        }
//    }
//    
//    @objc func rateAvgBtnTapped() {
//        let rateChartVC = RateChartViewController()
//        rateChartVC.chartD = self.chartData
//        rateChartVC.modalPresentationStyle = .pageSheet
//        present(rateChartVC, animated: true, completion: nil)
//    }
//}
