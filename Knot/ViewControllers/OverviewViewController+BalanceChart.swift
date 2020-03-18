//
//  OverviewViewController+BalanceChart.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-16.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation
import Charts

extension OverviewViewController: ChartViewDelegate {
    @IBAction func chartSegmentChanged(_ sender: UISegmentedControl) {
        timeIndicatorLabel.fadeOut()
        balanceIndicatorLabel.fadeOut()
        
        if let timePeriod = ChartTimePeriod(rawValue: chartSegmentedControl.selectedSegmentIndex) {
            
            var newChartData: BalanceChartDataSet
            
            switch timePeriod {
            case ChartTimePeriod.week:
                newChartData = balanceChartData_1w
            case ChartTimePeriod.month:
                newChartData = balanceChartData_1m
            case ChartTimePeriod.threeMonth:
                newChartData = balanceChartData_3m
            case ChartTimePeriod.sixMonth:
                newChartData = balanceChartData_6m
            case ChartTimePeriod.year:
                newChartData = balanceChartData_1y
            }
            
            balanceChartView.data?.dataSets[0] = newChartData
            
            if !newChartData.isCustomized {
                customizeBalanceChart()
                newChartData.isCustomized = true
            } else {
                balanceChartView.animate(yAxisDuration: 0.2, easingOption: ChartEasingOption.linear)
                balanceChartView.animate(xAxisDuration: 0.2, easingOption: ChartEasingOption.linear)
                balanceChartView.notifyDataSetChanged()
                highlightCurrentBalance()
            }
        }
    }
    
    func balanceChartData(for timePeriod: ChartTimePeriod) -> BalanceChartDataSet {
        let balances: [Double]
        
        switch timePeriod {
        case .week:
            balances = [32050, 100000, 500000, 250000, 20000, 20000, 32050, 100000, 500000, 250000, 20000, 20000]
        case .month:
            balances = [320500, 500000, 500000, 250000, 250000, 800000, 32050, 100000, 500000, 250000, 20000, 20000, 32050, 100000, 500000, 250000, 20000, 20000, 32050, 100000, 500000, 250000, 20000, 20000, 32050, 100000, 500000, 250000, 20000, 20000, 400000]
        case .threeMonth:
            balances = [32050, 500000, 100000, 250000, 250000, 800000, 20000]
        case .sixMonth:
            balances = [32050, 500000, 500000, 250000, 250000, 800000, 616000]
        case .year:
            balances = [3205000, 5000000, 9000000, 2500000, 2500000, 11800000, 11800000]
        }
        
        var lineChartEntry = [ChartDataEntry]()

        for i in 0..<balances.count {
            let value = ChartDataEntry(x: Double(i), y: Double(balances[i]), data: "Jan 30, 2020")
            lineChartEntry.append(value)
        }
        
        return BalanceChartDataSet(entries: lineChartEntry)
    }
    
    func setupBalanceChart() {
        balanceChartView.delegate = self
        
        let data = LineChartData()
        data.addDataSet(balanceChartData_1w)
        balanceChartView.data = data
        customizeBalanceChart()
        balanceChartData_1w.isCustomized = true
    }
    
    func customizeBalanceChart() {
        let balanceData = balanceChartView.data!.dataSets[0] as! LineChartDataSet
        
        balanceData.colors = [UIColor.systemBlue]
        balanceData.lineWidth = 2.0
        balanceData.drawCirclesEnabled = false
        balanceData.drawValuesEnabled = false
        
        balanceData.drawHorizontalHighlightIndicatorEnabled = false
        balanceData.highlightColor = UIColor.gray
        balanceData.highlightLineWidth = 2
        balanceData.highlightLineDashLengths = [2.0]
        
        balanceChartView.xAxis.enabled = false
        balanceChartView.leftAxis.enabled = false
        balanceChartView.rightAxis.enabled = false
        balanceChartView.rightAxis.drawGridLinesEnabled = false
        balanceChartView.legend.enabled = false
        balanceChartView.animate(yAxisDuration: 0.2, easingOption: ChartEasingOption.linear)
        balanceChartView.animate(xAxisDuration: 0.2, easingOption: ChartEasingOption.linear)
        balanceChartView.setScaleEnabled(false)
        
        drawGradient(for: balanceData, using: UIColor.systemBlue, bottomColour: UIColor.white)
        balanceIndicatorLabel.alpha = 0
        timeIndicatorLabel.alpha = 0

        balanceChartView.notifyDataSetChanged()
        highlightCurrentBalance()
    }
    
    func drawGradient(for lineChart: LineChartDataSet, using topColour: UIColor, bottomColour: UIColor) {
           let gradientColours = [topColour.cgColor, bottomColour.cgColor]
           let colourLocations: [CGFloat] = [0.7, 0.0]
           let gradient =
               CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                               colors: gradientColours as CFArray,
                               locations: colourLocations)!
           lineChart.drawFilledEnabled = true
           lineChart.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
    }
    
    func highlightCurrentBalance() {
        let xTouchPoint = balanceChartView.frame.width
        let yTouchPoint = balanceChartView.frame.height
        let highlight = balanceChartView.getHighlightByTouchPoint(CGPoint(x: xTouchPoint, y: yTouchPoint))
        balanceChartView.highlightValue(highlight, callDelegate: true)
    }
    
    // MARK: - Chart Delegate Functions
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        timeIndicatorLabel.center = CGPoint(x: highlight.xPx + 45, y: -7)
        balanceIndicatorLabel.center = CGPoint(x: highlight.xPx + 45, y: 10)
 
        timeIndicatorLabel.text = entry.data as? String
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let balance = formatter.string(from: highlight.y as NSNumber) {
            balanceIndicatorLabel.text = "\(balance)"
        }

        timeIndicatorLabel.fadeIn()
        balanceIndicatorLabel.fadeIn()
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        timeIndicatorLabel.fadeOut()
        balanceIndicatorLabel.fadeOut()
        chartView.highlightValue(nil)
    }
}