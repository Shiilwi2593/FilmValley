import UIKit
import DGCharts

class RateChartViewController: UIViewController, ChartViewDelegate {
    
    var barChartView: BarChartView!
    var chartContainerView: UIView!
    var chartD: [(rating: Int, count: Int)] = []
    var scrollView: UIScrollView!
    
    init(chartD: [(rating: Int, count: Int)]) {
        self.chartD = chartD
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Khởi tạo container view để chứa biểu đồ
        chartContainerView = UIView()
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartContainerView)
        
        NSLayoutConstraint.activate([
            chartContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Khởi tạo BarChartView và thêm vào container view
        barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.addSubview(barChartView)
        
        NSLayoutConstraint.activate([
            barChartView.centerXAnchor.constraint(equalTo: chartContainerView.centerXAnchor),
            barChartView.centerYAnchor.constraint(equalTo: chartContainerView.centerYAnchor),
            barChartView.widthAnchor.constraint(equalTo: chartContainerView.widthAnchor),
            barChartView.heightAnchor.constraint(equalTo: chartContainerView.heightAnchor, multiplier: 0.5) // Đặt chiều cao là một nửa chiều cao của container view
        ])
        // Thiết lập các thông số cho biểu đồ
        setupChart()
    }
    
    func setupChart() {
        // Tính tổng số lượt vote
        let totalVotes = chartD.reduce(0) { $0 + $1.count }
        let minValue: Double = 0.0
        
        var dataEntries: [BarChartDataEntry] = []
        for data in chartD {
            var percentage = Double(data.count) / Double(totalVotes) * 100.0
            if percentage == 0 {
                percentage = minValue
            }
            let dataEntry = BarChartDataEntry(x: Double(data.rating), y: percentage)
            dataEntries.append(dataEntry)
        }
        
        // Tạo BarChartDataSet
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Rating Distribution Chart")
        
        // Thiết lập dữ liệu cho biểu đồ
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Tùy chỉnh biểu đồ (tùy chọn)
        chartDataSet.colors = ChartColorTemplates.liberty()
        
        // Padding cho biểu đồ
        barChartView.setExtraOffsets(left: 10, top: 0, right: 0, bottom: 0)
        
        // Định dạng trục x
        let ratings = chartD.map { "            \($0.rating)" }
        let formatter = IndexAxisValueFormatter(values: ratings)
        barChartView.xAxis.valueFormatter = formatter
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.setLabelCount(ratings.count, force: false)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = true
        barChartView.xAxis.centerAxisLabelsEnabled = true
        
        // Thiết lập cho trục x
        barChartView.xAxis.axisMinimum = 0.5
        barChartView.xAxis.axisMaximum = 10.5
        
        // Thiết lập cho trục y để luôn bắt đầu từ 0
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 100
        barChartView.leftAxis.granularity = 10
        
        // Thiết lập cho trục y
        let yAxisFormatter = NumberFormatter()
        yAxisFormatter.numberStyle = .percent
        yAxisFormatter.multiplier = 1
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: yAxisFormatter)
        
        // Hiển thị trục y
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.leftAxis.drawAxisLineEnabled = true
        
        // Ẩn trục y bên phải
        barChartView.rightAxis.enabled = false
        
        // Thiết lập delegate
        barChartView.delegate = self
        
        // Animation (tùy chọn)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    // MARK: - ChartViewDelegate
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let barEntry = entry as? BarChartDataEntry else { return }
        let point = barEntry.x
        let votes = (chartD[Int(point) - 1].count) / 2
        let percentage = barEntry.y

        let alertController = UIAlertController(title: "Point: \(point)", message: "Votes: \(votes) (\(Int(percentage))%)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
