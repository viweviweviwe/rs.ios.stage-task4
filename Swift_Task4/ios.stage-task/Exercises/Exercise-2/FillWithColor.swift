import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {

        guard row < image.count && row >= 0 && column >= 0 else {
            return image
        }
        
        for i in image.indices {
            if image[i].count <= column{
                return image
            }
        }

        let m = image.count
        let n = image[row].count
        guard m >= 1 && n <= 50 && row <= m && column <= n && newColor < 65536 else {
            return image
        }
        
        var filImage = image
        let oldColor = image[row][column]
        guard oldColor != newColor else {
            return image
        }
        
        var fillPixels = [(row, column)]

        func findNeighbor(row : Int, column: Int) {
            // верхний сосед
            if ((row > 0) && (filImage[row - 1][column] == oldColor)) {
                fillPixels.append((row - 1, column))
            }// правый
            if (column < filImage[row].count - 1) && filImage[row][column + 1] == oldColor {
                fillPixels.append((row, column + 1))
            }//нижний
            if (row < filImage.count - 1) && filImage[row + 1][column] == oldColor {
                fillPixels.append((row + 1, column))
            }//левый
            if (column > 0) && (filImage[row][column - 1] == oldColor) {
                fillPixels.append((row, column - 1))
            }
        }
        
        while fillPixels.count != 0 {
            findNeighbor(row: fillPixels[0].0, column: fillPixels[0].1)
            filImage[fillPixels[0].0][fillPixels[0].1] = newColor
            fillPixels.removeFirst()
        }
        
        return filImage
    }
}
