/*
Copyright (c) 2015 Kyohei Yamaguchi. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

@objc public protocol KYDrawerControllerDelegate {
    optional func drawerController(drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState)
}

public class KYDrawerController: UIViewController, UIGestureRecognizerDelegate {
    
    /**************************************************************************/
    // MARK: - Types
    /**************************************************************************/
    
    @objc public enum DrawerDirection: Int {
        case Left, Right
    }
    
    @objc public enum DrawerState: Int {
        case Opened, Closed
    }
    
    private let _kContainerViewMaxAlpha  : CGFloat        = 0.2
    private let _kDrawerAnimationDuration: NSTimeInterval = 0.25
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    @IBInspectable var mainSegueIdentifier  : String?
    @IBInspectable var drawerSegueIdentifier: String?
    
    private var _drawerConstraint : NSLayoutConstraint!
    
    private var _panStartLocation = CGPointZero
    
    private var _panDelta: CGFloat = 0
    
    lazy private var _containerView: UIView = {
        let view = UIView(frame: self.view.frame)
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: "didtapContainerView:"
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0)
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        return view
    }()
    
    lazy private(set) var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: "handlePanGesture:"
        )
        switch self.drawerDirection {
        case .Left:
            gesture.edges = .Left
        case .Right:
            gesture.edges = .Right
        }
        gesture.delegate = self
        return gesture
    }()
    
    lazy private(set) var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: "handlePanGesture:"
        )
        gesture.delegate = self
        return gesture
    }()
    
    public weak var delegate         : KYDrawerControllerDelegate?
    
    public var drawerDirection      : DrawerDirection = .Left
    
    public var drawerState          : DrawerState! {
        get {
            return _containerView.hidden ? .Closed : .Opened
        }
        set {
            setDrawerState(drawerState, animated: false)
        }
    }
    
    @IBInspectable public var drawerWidth: CGFloat = 280
    
    public var mainViewController: UIViewController! {
        didSet {
            if let oldController = oldValue {
                oldController.willMoveToParentViewController(nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            if let mainViewController = mainViewController {
                let viewDictionary      = ["mainView" : mainViewController.view]
                mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
                addChildViewController(mainViewController)
                view.insertSubview(mainViewController.view, atIndex: 0)
                view.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-0-[mainView]-0-|",
                        options: [],
                        metrics: nil,
                        views: viewDictionary
                    )
                )
                view.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "H:|-0-[mainView]-0-|",
                        options: [],
                        metrics: nil,
                        views: viewDictionary
                    )
                )
                mainViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    public var drawerViewController : UIViewController? {
        didSet {
            if let oldController = oldValue {
                oldController.willMoveToParentViewController(nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            if let drawerViewController = drawerViewController {
                let viewDictionary      = ["drawerView" : drawerViewController.view]
                let itemAttribute: NSLayoutAttribute
                let toItemAttribute: NSLayoutAttribute
                switch drawerDirection {
                case .Left:
                    itemAttribute   = .Right
                    toItemAttribute = .Left
                case .Right:
                    itemAttribute   = .Left
                    toItemAttribute = .Right
                }
                
                drawerViewController.view.layer.shadowColor   = UIColor.blackColor().CGColor
                drawerViewController.view.layer.shadowOpacity = 0.4
                drawerViewController.view.layer.shadowRadius  = 5.0
                drawerViewController.view.translatesAutoresizingMaskIntoConstraints = false
                addChildViewController(drawerViewController)
                _containerView.addSubview(drawerViewController.view)
                drawerViewController.view.addConstraint(
                    NSLayoutConstraint(
                        item: drawerViewController.view,
                        attribute: NSLayoutAttribute.Width,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: nil,
                        attribute: NSLayoutAttribute.Width,
                        multiplier: 1,
                        constant: drawerWidth
                    )
                )
                _drawerConstraint = NSLayoutConstraint(
                    item: drawerViewController.view,
                    attribute: itemAttribute,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: _containerView,
                    attribute: toItemAttribute,
                    multiplier: 1,
                    constant: 0
                )
                _containerView.addConstraint(_drawerConstraint)
                _containerView.addConstraints(
                    NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-0-[drawerView]-0-|",
                        options: [],
                        metrics: nil,
                        views: viewDictionary
                    )
                )
                drawerViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    
    /**************************************************************************/
    // MARK: - initialize
    /**************************************************************************/
    
    public convenience init(drawerDirection: DrawerDirection, drawerWidth: CGFloat) {
        self.init()
        self.drawerDirection = drawerDirection
        self.drawerWidth     = drawerWidth
    }
    
    
    /**************************************************************************/
    // MARK: - Life Cycle
    /**************************************************************************/
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewDictionary = ["_containerView": _containerView]
        
        view.addGestureRecognizer(screenEdgePanGesture)
        view.addGestureRecognizer(panGesture)
        view.addSubview(_containerView)
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[_containerView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[_containerView]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        _containerView.hidden = true
        
        if let mainSegueID = mainSegueIdentifier {
            performSegueWithIdentifier(mainSegueID, sender: self)
        }
        if let drawerSegueID = drawerSegueIdentifier {
            performSegueWithIdentifier(drawerSegueID, sender: self)
        }
    }
    
    /**************************************************************************/
    // MARK: - Public Method
    /**************************************************************************/
    
    public func setDrawerState(state: DrawerState, animated: Bool) {
        _containerView.hidden = false
        let duration: NSTimeInterval = animated ? _kDrawerAnimationDuration : 0
        
        UIView.animateWithDuration(duration,
            delay: 0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                switch state {
                case .Closed:
                    self._drawerConstraint.constant     = 0
                    self._containerView.backgroundColor = UIColor(white: 0, alpha: 0)
                case .Opened:
                    let constant: CGFloat
                    switch self.drawerDirection {
                    case .Left:
                        constant = self.drawerWidth
                    case .Right:
                        constant = -self.drawerWidth
                    }
                    self._drawerConstraint.constant     = constant
                    self._containerView.backgroundColor = UIColor(
                        white: 0
                        , alpha: self._kContainerViewMaxAlpha
                    )
                }
                self._containerView.layoutIfNeeded()
            }) { (finished: Bool) -> Void in
                if state == .Closed {
                    self._containerView.hidden = true
                }
                self.delegate?.drawerController?(self, stateChanged: state)
        }
    }
    
    /**************************************************************************/
    // MARK: - Private Method
    /**************************************************************************/
    
    final func handlePanGesture(sender: UIGestureRecognizer) {
        _containerView.hidden = false
        if sender.state == .Began {
            _panStartLocation = sender.locationInView(view)
        }
        
        let delta           = CGFloat(sender.locationInView(view).x - _panStartLocation.x)
        let constant        : CGFloat
        let backGroundAlpha : CGFloat
        let drawerState     : DrawerState
        
        switch drawerDirection {
        case .Left:
            drawerState     = _panDelta < 0 ? .Closed : .Opened
            constant        = min(_drawerConstraint.constant + delta, drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha*(abs(constant)/drawerWidth)
            )
        case .Right:
            drawerState     = _panDelta > 0 ? .Closed : .Opened
            constant        = max(_drawerConstraint.constant + delta, -drawerWidth)
            backGroundAlpha = min(
                _kContainerViewMaxAlpha,
                _kContainerViewMaxAlpha*(abs(constant)/drawerWidth)
            )
        }
        
        _drawerConstraint.constant = constant
        _containerView.backgroundColor = UIColor(
            white: 0,
            alpha: backGroundAlpha
        )
        
        switch sender.state {
        case .Changed:
            _panStartLocation = sender.locationInView(view)
            _panDelta         = delta
        case .Ended, .Cancelled:
            setDrawerState(drawerState, animated: true)
        default:
            break
        }
    }
    
    final func didtapContainerView(gesture: UITapGestureRecognizer) {
        setDrawerState(.Closed, animated: true)
    }
    
    
    /**************************************************************************/
    // MARK: - UIGestureRecognizerDelegate
    /**************************************************************************/
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        switch gestureRecognizer {
        case panGesture:
            return drawerState == .Opened
        case screenEdgePanGesture:
            return drawerState == .Closed
        default:
            return touch.view == gestureRecognizer.view
        }
    }


}

