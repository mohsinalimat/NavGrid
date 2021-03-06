//
//  NavGridSampleCompositionNavigationController.swift
//  NavGrid
//
//  Created by Patrick Bradshaw on 1/10/16.
//  Copyright © 2016 Patrick Bradshaw. All rights reserved.
//

import Foundation
import UIKit

class NavGridSampleCompositionNavigationController : UIViewController, NGNavigationButtonDelegate {
    let mNavGrid = NGNavigationController()
    var mGridAlignment : NavGridAlignment = .Grid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load our NavGrid into our view
        //mNavGrid.view.frame = CGRectMake(15, 15, view.frame.width / 5.0, view.frame.height / 5.0) // Testing for behaviour purposes
        //mNavGrid.ngncResetNavigationHeaderToDefaults() // Testing for behaviour purposes
        view.addSubview(mNavGrid.view)
        
        // Implement your own behavior for adding view controllers here
        let colorArray = [[UIColor.blackColor(), UIColor.greenColor(), UIColor.yellowColor()], [UIColor.grayColor(), UIColor.purpleColor(), UIColor.orangeColor()], [UIColor.blueColor(), UIColor.brownColor(), UIColor.darkGrayColor()]]
        
        
        for i in 0...2 {
            for j in 0...2 {
                do {
                    // Ideally, each new controller added should be inside it's own do-try-catch clause in order to prevent an early error from preventing later controllers being added
                    let colorView = NavGridSampleViewController()
                    colorView.view.backgroundColor = colorArray[i][j]
                    colorView.mNGTitle = String(i, j)
                    
                    // Set up our two named controllers for reference purposes
                    if i == 0 && j == 0 {
                        let label = UILabel(frame: colorView.view.frame)
                        label.frame.size.height -= mNavGrid.ngncGetNavBarHeightWithStatusBar()
                        label.backgroundColor = UIColor.clearColor()
                        label.textColor = UIColor.whiteColor()
                        label.text = "Profile"
                        label.textAlignment = .Center
                        label.font = UIFont.systemFontOfSize(56)
                        label.adjustsFontSizeToFitWidth = true
                        colorView.view.addSubview(label)
                    } else if i == 1 && j == 1 {
                        let label = UILabel(frame: colorView.view.frame)
                        label.frame.size.height -= mNavGrid.ngncGetNavBarHeightWithStatusBar()
                        label.backgroundColor = UIColor.clearColor()
                        label.textColor = UIColor.whiteColor()
                        label.text = "Search"
                        label.textAlignment = .Center
                        label.font = UIFont.systemFontOfSize(56)
                        label.adjustsFontSizeToFitWidth = true
                        colorView.view.addSubview(label)
                    }
                    
                    // Actually append the view controller (we do this last so that we can use the original frame anchored at 0,0 in our label creation rather than the newly assigned frame uppon appending to the grid)
                    try mNavGrid.ngncAppendNGViewControllerToLocation(i, y: j, vc: colorView)
                } catch NGGridError.ViewControllerAlreadyExists {
                    // This will occur if a view controller already exists at this location
                } catch {
                    // Should never occur
                }
            }
        }
        
        // Enable swipe transitions
        mNavGrid.ngncEnableSwipeNavigation()
        
        // Set our button delegate
        mNavGrid.ngncSetDelegate(self)
        
        // Navigate to starting page
        do {
            try mNavGrid.ngncNavigateToLocation(0, y: 0)
        } catch NGGridError.GridMoveAttemptPastBounds {
            // We are already at the right edge
        } catch NGGridError.ViewControllerDoesNotExist {
            // We attempted to move to a grid location that contains no view controller
        } catch {
            // Should never occur
            fatalError()
        }
        
        // Set our rows to be disaligned
        mNavGrid.ngncSetLeftButton(nil, title: "Rows Disaligned", state: .Normal, backgroundColor: nil, rounded: false)
        mGridAlignment = .RowsDisaligned
        mNavGrid.rowsAligned = false
        //mNavGrid.columnsAligned = true
    }
    
    // MARK: Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: Button Delegate Methods
    func ngdLeftButtonTouchDown() {
        // STUB
    }
    func ngdLeftButtonTouchUpOutside() {
        // STUB
    }
    func ngdLeftButtonTouchUpInside() {
        if mGridAlignment == .Grid {
            mNavGrid.ngncSetRowsAligned(false, animated: true)
            mNavGrid.ngncSetLeftButton(nil, title: "Rows Disaligned", state: .Normal, backgroundColor: nil, rounded: false)
            mGridAlignment = .RowsDisaligned
        } else if mGridAlignment == .RowsDisaligned {
            mNavGrid.ngncSetColumnsAligned(false, animated: true)
            mNavGrid.ngncSetLeftButton(nil, title: "Columns Disaligned", state: .Normal, backgroundColor: nil, rounded: false)
            mGridAlignment = .ColumnsDisaligned
        } else if mGridAlignment == .ColumnsDisaligned {
            mNavGrid.ngncSetColumnsAligned(true, animated: true)
            mNavGrid.ngncSetLeftButton(nil, title: "Grid", state: .Normal, backgroundColor: nil, rounded: false)
            mGridAlignment = .Grid
        }
    }
    func ngdRightButtonTouchDown() {
        // STUB
    }
    func ngdRightButtonTouchUpOutside() {
        // STUB
    }
    func ngdRightButtonTouchUpInside() {
        // STUB
        do {
            try mNavGrid.ngncNavigateToLocation(1, y: 1)
        } catch NGGridError.GridMoveAttemptPastBounds {
            // We are already at the bottom edge
        } catch NGGridError.ViewControllerDoesNotExist {
            // The requested move location is not a valid view controller
        } catch {
            // Should never occur
            fatalError()
        }
    }
}
