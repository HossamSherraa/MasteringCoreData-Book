//
//  NoteCellView.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 17/02/2021.
//

import UIKit
class NoteCellView : UITableViewCell {
    private let titleLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
   
    private let dateLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
   private  let subTitleLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
    }()
    
    
   private  let contentLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 17, weight: .regular)
    label.textColor = .gray
    label.numberOfLines = 0
    return label
    }()
    
   private let colorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()
    
    
    private func configViewLayout(){
        
        //ADD SubViews
        self.contentView.addSubview(colorView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(subTitleLabel)
        self.contentView.addSubview(contentLabel)
        
        //Constraints
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: colorView.bottomAnchor),
            colorView.widthAnchor.constraint(lessThanOrEqualToConstant: 5),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 10),
            
            
            contentView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor , constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor , constant: 10),
            contentView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor , constant: 10),
            
            contentView.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor , constant: 10)
            
        
        ])
        
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configCellWith(title : String , date : String , subtitle : String , content : String , color : UIColor = UIColor.gray){
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.subTitleLabel.text = subtitle
        self.contentLabel.text = content
        self.colorView.backgroundColor = color
        
    }
}
