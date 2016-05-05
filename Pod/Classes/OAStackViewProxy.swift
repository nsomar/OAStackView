//
//  OAStackViewProxy.swift
//  Masilotti.com
//
//  Created by Joe Masilotti on 5/4/16.
//  Copyright © 2016 Masilotti.com. All rights reserved.
//

import UIKit

@objc public class OAStackViewProxy: UIView {
    public init() {
        super.init(frame: CGRectZero)
        if #available(iOS 9, *) {
            installFullScreenView(nativeStackView)
        } else {
            installFullScreenView(backwardsCompatibleStackView)
        }
    }

    public init(arrangedSubviews: [UIView]) {
        super.init(frame: CGRectZero)
        if #available(iOS 9, *) {
            installFullScreenView(nativeStackView)
            arrangedSubviews.forEach({ (view) in nativeStackView.addArrangedSubview(view) })
        } else {
            installFullScreenView(backwardsCompatibleStackView)
            arrangedSubviews.forEach({ (view) in backwardsCompatibleStackView.addArrangedSubview(view) })
        }
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("Unimplemented.") }

    override public var subviews: [UIView] {
        if #available(iOS 9, *) {
            return nativeStackView.subviews
        } else {
            return backwardsCompatibleStackView.subviews
        }
    }

    public var arrangedSubviews: [UIView] {
        if #available(iOS 9, *) {
            return nativeStackView.arrangedSubviews
        } else {
            return backwardsCompatibleStackView.arrangedSubviews
        }
    }

    public func addArrangedSubview(view: UIView) {
        if #available(iOS 9, *) {
            nativeStackView.addArrangedSubview(view)
        } else {
            backwardsCompatibleStackView.addArrangedSubview(view)
        }
    }

    public func removeArrangedSubview(view: UIView) {
        if #available(iOS 9, *) {
            nativeStackView.removeArrangedSubview(view)
        } else {
            backwardsCompatibleStackView.removeArrangedSubview(view)
        }
    }

    public var axis: UILayoutConstraintAxis = .Horizontal {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.axis = axis
            } else {
                backwardsCompatibleStackView.axis = axis
            }
        }
    }

    public var distribution: OAStackViewDistribution = .Fill {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.distribution = UIStackViewDistribution(distribution: distribution)
            } else {
                backwardsCompatibleStackView.distribution = distribution
            }
        }
    }

    public var alignment: OAStackViewAlignment = .Fill {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.alignment = UIStackViewAlignment(alignment: alignment)
            } else {
                backwardsCompatibleStackView.alignment = alignment
            }
        }
    }

    public var spacing: CGFloat = 0.0 {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.spacing = spacing
            } else {
                backwardsCompatibleStackView.spacing = spacing
            }
        }
    }

    public var baselineRelativeArrangement: Bool = false {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.baselineRelativeArrangement = baselineRelativeArrangement
            }
        }
    }

    public var layoutMarginsRelativeArrangement: Bool = false {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.layoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement
            }
        }
    }

    @available(iOS 9.0, *)
    private lazy var nativeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var backwardsCompatibleStackView: OAStackView = {
        let stackView = OAStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}

@available(iOS 8, *)
public extension OAStackViewProxy {
    public override var layoutMargins: UIEdgeInsets {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.layoutMargins = layoutMargins
            } else {
                backwardsCompatibleStackView.layoutMargins = layoutMargins
            }
        }
    }
}

@available(iOS 9, *)
private extension UIStackViewAlignment {
    init(alignment: OAStackViewAlignment) {
        switch alignment {
        case .Fill:
            self = .Fill
        case .Leading:
            self = .Leading
        case .FirstBaseline:
            self = .FirstBaseline
        case .Center:
            self = .Center
        case .Trailing:
            self = .Trailing
        case .Baseline:
            self = .FirstBaseline
        }
    }
}

@available(iOS 9, *)
private extension UIStackViewDistribution {
    init(distribution: OAStackViewDistribution) {
        switch distribution {
        case .Fill:
            self = .Fill
        case .FillEqually:
            self = .FillEqually
        case .FillProportionally:
            self = .FillProportionally
        case .EqualSpacing:
            self = .EqualSpacing
        case .EqualCentering:
            self = .EqualCentering
        }
    }
}

private extension UIView {
    func installFullScreenView(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
    }
}
