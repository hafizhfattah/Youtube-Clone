//
//  VideoTableViewCell.swift
//  Youtube Clone
//
//  Created by Macbook on 25/03/21.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    var video:Video?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //inisialisasi
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //mengkonfigur tampilan dari state yang dituju
    }
    
    func setCell(_ v:Video) {
        
        self.video = v
        
        //Meyakinkan kembali data video dari link json
        
        guard self.video != nil else {
            return
        }
        
        //Set Title
        
        self.titleLabel.text = video?.title
        
        // Set tanggal
        
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM, D, YYYY"
        self.dataLabel.text = df.string(from: video!.published)
        
        //Set Thumbnail
        guard self.video!.thumbnail != "" else {
            return
        }
        
        //cek cache sebelum mengunduh data
        
        if let cachedData = CacheManager.getVideoCache(self.video!.thumbnail) {
            
            //set tampilan ImageView
            self.thumbnailImageView.image = UIImage(data: cachedData)
            return
        }
        //Mengunduh data thumbnail
        let url = URL(string: self.video!.thumbnail)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                //Menyimpan data di cache
                CacheManager.setVideoCache(url!.absoluteString, data)
                
                //Cek kembali url yang dimasukkan cocok untuk thumbnail yang akan ditampilkan
                if url!.absoluteString != self.video?.thumbnail {
                    // Thumbnail video telah diatur kembali untuk video lain
                    
                    return
                }
                // Membuat image object
                let image = UIImage(data: data!)
                
                //set imageView
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }
        }
        //memulai tugasnya
        dataTask.resume()
    }
}
