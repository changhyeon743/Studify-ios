//
//  ChartView.swift
//  Studify
//
//  Created by 이창현 on 13/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Charts

class ChartView: UIView {
    
    var container: UIView = UIView()
    var close: UIButton = UIButton()
    var chartView: BarChartView = BarChartView(frame: CGRect.zero)
    var alertView: UIView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setTransform(to: CGRect) {
        container.frame = to
        container.frame = CGRect(x: to.origin.x, y: to.origin.y+20, width: 200, height: 100)
    }
    
    init(uiView: UIView) {
        super.init(frame: CGRect.zero)
        self.layer.zPosition = -1
        
        
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0)
        container.isHidden = true
        
        
        
        close.frame = CGRect(x: container.frame.width-120, y: 50, width: 100, height: 30)
        close.setTitle("닫기", for: .normal)
        close.setTitleColor(.black, for: .normal)
        close.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        close.isHidden = true
        
        alertView.frame = CGRect(x: 0, y: 0, width: uiView.frame.width-80, height: uiView.frame.height/3)
        alertView.backgroundColor = .white
        alertView.center = container.center
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 10
        alertView.isHidden = true
        
        chartView.frame = CGRect(x: 0, y: 0, width: uiView.frame.width-80, height: uiView.frame.height/3)
        chartView.center = container.center
        chartView.backgroundColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.highlighter = nil
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        
        
        
        chartView.isHidden = true
        
        //loadingView.addSubview(actInd)
        //loadingView.insertSubview(label, aboveSubview: actInd)
        //alertView.addSubview(chartView)
        container.addSubview(close)
        container.addSubview(alertView)
        uiView.addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close(_ button: UIButton) {
        hide();
    }
    
    func show() {
        container.isHidden = false
        chartView.isHidden = false
        close.isHidden = false
        alertView.isHidden = false
    }
    
    func hide() {
        container.isHidden = true
        chartView.isHidden = true
        close.isHidden = true
        alertView.isHidden = true
    }
    
    func show(viewController: UIViewController,title: String) {
        chartView.isHidden = false
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        chartView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        chartView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 390).isActive = true
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func setData(xVals: [String], dataPoints: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "총 공부량(분)" )
        //chartDataSet.colors = [.red,.blue,.green]
        chartDataSet.colors = ChartColorTemplates.joyful()
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xVals)
        chartView.xAxis.setLabelCount(xVals.count, force: false)
        
        
        chartView.data = chartData
        chartView.animate(yAxisDuration: 1, easingOption: .easeInOutQuart)

    }
}
