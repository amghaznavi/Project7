//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by Am GHAZNAVI on 10/11/2019.
//  Copyright © 2019 Am GHAZNAVI. All rights reserved.
//


import UIKit
import Charts

class ProgressViewController : UIViewController {
    
    @IBOutlet weak var barChartView: HorizontalBarChartView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var labels = [String]()
    var achievedGoals = [Double]()
    var achievedTasks = [Double]()
    var goalData: BarChartDataSet!
    var taskData: BarChartDataSet!
    private var model : Progress!
    private let dataController = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = Progress(self.dataController)
        configure()
    }
    
    func configure() {
        model = Progress(self.dataController)
        segmentControl.selectedSegmentIndex = 0
        barChartView.noDataText = "You need to provide data for this chart."
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.yOffset = 10
        legend.xOffset = 5
        legend.orientation = .horizontal
        legend.drawInside = true
        
        let xaxis = barChartView.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: self.labels)
        xaxis.setLabelCount(self.labels.count, force: false)
        
        barChartView.drawValueAboveBarEnabled = true
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false
        
        let leftAxis = barChartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        leftAxis.drawGridLinesEnabled = true
        
        // Background colors
        barChartView.backgroundColor = UIColor.focusOnBackgroundColor
        barChartView.tintColor = .white
        barChartView.drawGridBackgroundEnabled = true
        barChartView.gridBackgroundColor = UIColor.white
        // Disabling user interaction features
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = true
        
        barChartView.minOffset = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDataInGraph()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.loadDataInGraph(isEmpty: true)
    }
    
    @IBAction func periodChanged() {
        self.loadDataInGraph()
    }
    
    // Setup horizontal barchart accordingly to the data
    private func loadDataInGraph(isEmpty: Bool = false) {
        let index = isEmpty ? -1 : self.segmentControl.selectedSegmentIndex
        switch index {
        case StringPlus.monthlySegmentIndex:
            let tuple = model.completedFocuses(isWeekly: false)
            self.achievedGoals = tuple.0
            self.achievedTasks = tuple.1
            self.labels = model.labels
        case StringPlus.weeklySegmentIndex:
            let tuple = model.completedFocuses(isWeekly: true)
            self.achievedGoals = tuple.0
            self.achievedTasks = tuple.1
            self.labels = model.labels
        default:
            self.labels = [String]()
            self.achievedGoals = [Double]()
            self.achievedTasks = [Double]()
        }
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter(values: self.labels)
        xaxis.setLabelCount(self.labels.count, force: false)
        
        setChart()
    }
    
    // Load or remove data
    private func setChart() {
        if achievedGoals.isEmpty && achievedTasks.isEmpty {
            barChartView.data = nil
            barChartView.notifyDataSetChanged()
        } else {
            updateDataSet()
            updateBarChartData()
            barChartView.notifyDataSetChanged()
        }
    }
    // Setup bars
    private func updateBarChartData() {
        let chartData = BarChartData(dataSets: [taskData, goalData])
        chartData.setValueFormatter(Formatter())
        let barWidth = 0.4
        let barSpace = 0.0
        let groupSpace = 0.2
        chartData.barWidth = barWidth
        // (0.4 + 0.00) * 2 + 0.2 = 1.00 -> interval per "group"
        // (barWidth + barSpace) * (no.of.bars) + groupSpace = 1.00 -> interval per "group"
        let groupCount = self.labels.count
        let startYear = 0
        
        barChartView.xAxis.axisMinimum = Double(startYear)
        barChartView.xAxis.axisMaximum = Double(startYear) + Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.data = chartData
    }
    // Setup legend, grid and data
    private func updateDataSet() {
        var goalDataEntries: [BarChartDataEntry] = []
        var taskDataEntries: [BarChartDataEntry] = []
        
        for i in 0..<self.labels.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.achievedGoals[i])
            goalDataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.achievedTasks[i])
            taskDataEntries.append(dataEntry1)
        }
        
        goalData = BarChartDataSet(entries: goalDataEntries, label: "% goals completed")
        taskData = BarChartDataSet(entries: taskDataEntries, label: "% tasks completed")
        
        goalData.colors = [UIColor.focusOnBlack]
        goalData.highlightColor = .clear
        goalData.drawValuesEnabled = true
        
        taskData.colors = [UIColor.focusOnGrey]
        taskData.highlightColor = .clear
        taskData.drawValuesEnabled = true
    }
}

class Formatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return value == 0.0 ? "" : String.init(format: "%.0f", value.rounded())
    }
}



