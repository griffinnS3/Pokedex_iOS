
import UIKit
import Kingfisher
import SnapKit

class PokedexCell: UICollectionViewCell {
    let label = UILabel()
    let imageView = UIImageView()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().inset(16)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.width.equalToSuperview()
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
