
import UIKit
import Kingfisher
import SnapKit

class PokedexCell: UICollectionViewCell {
    let label = UILabel()
    let imageView = UIImageView()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        label.textAlignment = .center
        //https://blog.devgenius.io/creating-stroked-labels-with-uikit-a-how-to-guide-7a024652e978
        label.attributedText = NSAttributedString(string: "Backed", attributes: [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 25, weight: .semibold),
            .strokeWidth: -5
        ])
        label.textColor = .white
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(imageView.snp.width).inset(40)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
 
    func configure(entry: PokemonEntry) {
        label.text = entry.name
        
        if let spriteURL = entry.spriteURL {
            imageView.kf.setImage(with: spriteURL,
        placeholder: UIImage(systemName: "photo"),
            options: [.transition(.fade(1)),
                .cacheOriginalImage
                ]
            )
        }
    }
    
}
