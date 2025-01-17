//
//  AUiTableViewCell.swift
//  AUiKit
//
//  Created by wushengtao on 2023/4/1.
//

import Foundation
import SwiftTheme


public protocol AUiTableViewItemProtocol: NSObject {
    var aui_style: AUiTableViewCellStyle {get}
    var aui_title: String? {get}
    var aui_subTitle: String? {get}
    var aui_Detail: String? {get}
    var aui_badge: String? {get}
    var aui_isSwitchOn: Bool {get}
    
    var onSwitchTapped: ((Bool)->())? {set get}
    
    var onCellSelected: ((IndexPath)->())? {set get}
}

open class AUiTableViewCellTheme: NSObject {
    public var titleFont: ThemeFontPicker = "TableViewCell.titleFont"           //主标题字体
    public var titleColor: ThemeColorPicker = "CommonColor.normalTextColor"         //主标题字体颜色
    public var subTitleFont: ThemeFontPicker = "TableViewCell.subTitleFont"        //副标题字体
    public var subTitleColor: ThemeColorPicker = "CommonColor.normalTextColor50"      //副标题字体颜色
    public var detailFont: ThemeFontPicker = "TableViewCell.detailFont"     //详情字体
    public var detailColor: ThemeColorPicker = "CommonColor.grey"     //详情字体颜色
    
    public var highlightColor: ThemeColorPicker = "CommonColor.danger"   //必填项星号
    
    public var badgeFont: ThemeFontPicker = "TableViewCell.badgeFont"       //角标字体
    public var badgeColor: ThemeColorPicker = "CommonColor.normalTextColor"     //角标字体颜色
    public var badgeBackgroundColor: ThemeColorPicker = "CommonColor.danger"    //角标背景色
    
    public var switchTintColor: ThemeColorPicker = "CommonColor.primary"
    public var switchThumbColor: ThemeColorPicker = "CommonColor.normalTextColor"
    
    public var arrow: ThemeImagePicker = "TableViewCell.arrow"    //箭头
}

//@objc
public struct AUiTableViewCellStyle: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let title = AUiTableViewCellStyle(rawValue: 1 << 0)
    public static let subTitle = AUiTableViewCellStyle(rawValue: 1 << 1)
    public static let detail = AUiTableViewCellStyle(rawValue: 1 << 2)
    public static let badge = AUiTableViewCellStyle(rawValue: 1 << 3)
    public static let uiswitch = AUiTableViewCellStyle(rawValue: 1 << 4)
    public static let arrow = AUiTableViewCellStyle(rawValue: 1 << 5)
    public static let highlight = AUiTableViewCellStyle(rawValue: 1 << 6)
    
    
    public static let singleLabel: AUiTableViewCellStyle = [.title]
    public static let multiLabel: AUiTableViewCellStyle = [.title, .subTitle]
    public static let singleLabelWithDetail: AUiTableViewCellStyle = [.title, .detail]
    public static let singleLabelWithBadgeAndArrow: AUiTableViewCellStyle = [.title, .badge, .arrow]
    public static let multiLabelWithArrow: AUiTableViewCellStyle = [.title, .subTitle, .arrow]
    public static let singleLabelWithDetailAndArrow: AUiTableViewCellStyle = [.title, .detail, .arrow]
    public static let singleLabelWithSwitch: AUiTableViewCellStyle = [.title, .uiswitch]
    public static let multiLabelWithSwitch: AUiTableViewCellStyle = [.title, .subTitle, .uiswitch]
}


private let kLeftPadding:CGFloat = 16
private let kRightPadding:CGFloat = 25
private let kArrowSize: CGSize = CGSize(width: 6, height: 12)
private let kWidgetPadding: CGFloat = 9
open class AUiTableViewCell: UITableViewCell {
    public var theme: AUiTableViewCellTheme = AUiTableViewCellTheme() {
        didSet {
            _resetTheme()
        }
    }
    
    public var item: AUiTableViewItemProtocol? {
        didSet {
            _resetStyle()
        }
    }
    
    public lazy var aui_highlightView: UILabel = {
        let label = UILabel()
        label.text = "*"
        return label
    }()
    public lazy var aui_titleLabel: UILabel = UILabel()
    public lazy var aui_subTitleLabel: UILabel = UILabel()
    public lazy var aui_detailLabel = UILabel()
    public lazy var aui_badgeLabel = UILabel()
    private lazy var aui_arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.aui_size = kArrowSize
        return imageView
    }()
    
    public lazy var aui_switch: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(onSwitchTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _loadSubViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        _loadSubViews()
    }
    
    private func _loadSubViews() {
        backgroundColor = .clear
        contentView.addSubview(aui_titleLabel)
        contentView.addSubview(aui_subTitleLabel)
        contentView.addSubview(aui_detailLabel)
        contentView.addSubview(aui_badgeLabel)
        contentView.addSubview(aui_switch)
        contentView.addSubview(aui_arrowView)
        contentView.addSubview(aui_highlightView)
        
        _resetStyle()
        _resetTheme()
    }
    
    private func _resetStyle() {
        guard let item = item else {return}
        
        aui_titleLabel.text = item.aui_title
        aui_subTitleLabel.text = item.aui_subTitle
        aui_badgeLabel.text = item.aui_badge
        aui_detailLabel.text = item.aui_Detail
        aui_switch.isOn = item.aui_isSwitchOn
        
        aui_titleLabel.isHidden = !item.aui_style.contains(.title)
        aui_subTitleLabel.isHidden = !item.aui_style.contains(.subTitle)
        aui_detailLabel.isHidden = !item.aui_style.contains(.detail)
        aui_badgeLabel.isHidden = !item.aui_style.contains(.badge)
        aui_switch.isHidden = !item.aui_style.contains(.uiswitch)
        aui_arrowView.isHidden = !item.aui_style.contains(.arrow)
        aui_highlightView.isHidden = !item.aui_style.contains(.highlight)
    }
    
    private func _resetTheme() {
        aui_highlightView.theme_font = theme.titleFont
        aui_highlightView.theme_textColor = theme.highlightColor
        
        aui_titleLabel.theme_font = theme.titleFont
        aui_titleLabel.theme_textColor = theme.titleColor
        
        aui_subTitleLabel.theme_font = theme.subTitleFont
        aui_subTitleLabel.theme_textColor = theme.subTitleColor
        
        aui_detailLabel.theme_font = theme.detailFont
        aui_detailLabel.theme_textColor = theme.detailColor
        
        aui_badgeLabel.theme_font = theme.badgeFont
        aui_badgeLabel.theme_textColor = theme.badgeColor
        aui_badgeLabel.theme_backgroundColor = theme.badgeBackgroundColor
        
        aui_switch.theme_onTintColor = theme.switchTintColor
        aui_switch.theme_thumbTintColor = theme.switchThumbColor
        
        aui_arrowView.theme_image = theme.arrow
    }
    
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        guard let item = item else {return}
        
        if item.aui_style.contains(.title) {
            aui_titleLabel.sizeToFit()
        }
        if item.aui_style.contains(.subTitle) {
            aui_subTitleLabel.sizeToFit()
        }
        if item.aui_style.contains(.detail) {
            aui_detailLabel.sizeToFit()
        }
        if item.aui_style.contains(.badge) {
            aui_badgeLabel.sizeToFit()
            aui_badgeLabel.textAlignment = .center
            let badgeWidth = max(aui_badgeLabel.aui_width + 8, aui_badgeLabel.aui_height + 8)
            aui_badgeLabel.aui_size = CGSize(width: badgeWidth, height: aui_badgeLabel.aui_height + 8)
            aui_badgeLabel.layer.cornerRadius = aui_badgeLabel.aui_height / 2
            aui_badgeLabel.clipsToBounds = true
        }
        if item.aui_style.contains(.highlight) {
            aui_highlightView.sizeToFit()
        }
        
        var contentHeight = aui_titleLabel.aui_height
        if !aui_subTitleLabel.isHidden {
            contentHeight += aui_subTitleLabel.aui_height
            aui_subTitleLabel.aui_bl = CGPoint(x: kLeftPadding, y: (aui_height + contentHeight) / 2)
        }
        aui_titleLabel.aui_tl = CGPoint(x: kLeftPadding, y: (aui_height - contentHeight) / 2)
        
        if !aui_highlightView.isHidden {
            aui_highlightView.aui_tl = CGPoint(x: aui_titleLabel.aui_right + kWidgetPadding, y: aui_titleLabel.aui_top)
        }
        
        var rightPadding = aui_width - kRightPadding
        if !aui_arrowView.isHidden {
            aui_arrowView.aui_center = CGPoint(x: rightPadding - aui_arrowView.aui_width, y: aui_height / 2)
            rightPadding = aui_arrowView.aui_left - kWidgetPadding
        }
        
        if !aui_badgeLabel.isHidden {
            aui_badgeLabel.aui_center = CGPoint(x: rightPadding - aui_badgeLabel.aui_width / 2, y: aui_height / 2)
            rightPadding = aui_badgeLabel.aui_left - kWidgetPadding
        }
        
        if !aui_switch.isHidden {
            aui_switch.aui_center = CGPoint(x: rightPadding - aui_switch.aui_width / 2, y: aui_height / 2)
            rightPadding = aui_arrowView.aui_left - kWidgetPadding
        }
        
        if !aui_detailLabel.isHidden {
            aui_detailLabel.aui_center = CGPoint(x: rightPadding - aui_detailLabel.aui_width / 2, y: aui_height / 2)
        }
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        if item?.aui_style.contains(.uiswitch) ?? false {
            return
        }
        super.setSelected(selected, animated: animated)
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if item?.aui_style.contains(.uiswitch) ?? false {
            return
        }
        super.setHighlighted(highlighted, animated: animated)
    }
    
    @objc func onSwitchTapped(_ sender: UISwitch) {
        guard let item = item else {return}
        item.onSwitchTapped?(sender.isOn)
    }
}

extension AUiTableViewCell{
    public static func tableViewCellDefaultHeight(style: AUiTableViewCellStyle) -> CGFloat {
        if style.contains(.subTitle) {
            return 65
        }
        
        return 48
    }
}
