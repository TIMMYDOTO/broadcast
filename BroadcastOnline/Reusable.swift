//
//  Reusable.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 20.12.2021.
//

import UIKit

private protocol Reusable: AnyObject {
    
    static var reuseIdentifier: String { get }
    
    static var nib: UINib { get }
    
}

private extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension UITableViewCell: Reusable {}

extension UITableView {
    func register<Cell: UITableViewCell>(_: Cell.Type) {
        self.register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue a \(String(describing: Cell.self)) cell.")
        }
        return cell
    }
}

extension UICollectionReusableView: Reusable {}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(nib: Cell.Type) {
        self.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func register<Cell: UICollectionViewCell>(type: Cell.Type) {
        self.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func register<View: UICollectionReusableView>(type: View.Type, forSupplementaryViewOfKind: String) {
        self.register(View.self, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: View.reuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue a \(String(describing: Cell.self)) cell.")
        }
        return cell
    }
    
    func dequeueReusableView<View: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> View {
        guard let view = self.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: View.reuseIdentifier, for: indexPath) as? View else {
            fatalError("Unable to dequeue a \(String(describing: View.self)) view.")
        }
        return view
    }
}
