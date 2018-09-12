//
//  ASSampleViewController.swift
//  OreCon-2018-Summer-Sample
//
//  Created by svpcadmin on 2018/09/12.
//  Copyright © 2018年 Fumito Ito. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class ASSampleViewController: ASViewController<ASDisplayNode> {

    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()

        node.delegate = self
        node.dataSource = self
        // この値を調整することでどのタイミングでprefetchを発火するのか制御することができる
        node.leadingScreensForBatching = 2

        // ASTableNodeはASCellNodeの再利用をしないのでregisterCellが不要
        return node
    }()

    init() {
        let node = ASDisplayNode()
        // これを指定しておくとlayoutSpecでこのNodeにぶら下がるNodeはaddSubnodeしなくても自動的にviewに表示される
        node.automaticallyManagesSubnodes = true

        super.init(node: node)

        // レイアウトの配置はnodeのlayoutSpecBlockプロパティにASLayoutSpecを返すクロージャを渡す
        node.layoutSpecBlock = { [weak self] node, constraintSize -> ASLayoutSpec in
            guard let `self` = self else { return ASLayoutSpec() }

            // 基本はCSS FlexboxライクなAPIでレイアウトを行うが、あるあるなレイアウトに関しては
            // 簡単に実装できるラッパーが存在する
            return ASWrapperLayoutSpec(layoutElement: self.tableNode)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ASSampleViewController: ASTableDelegate {
    // ASTableDelegateとUITableViewDelegateの間には大きな差異はない
}

extension ASSampleViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        // ASCellNodeを直接返すのではなくASCellNodeを返すクロージャを返す
        return {
            // このクロージャ内はメインスレッド以外で実行されるのでスレッドセーフなオブジェクトにしか触れない
            return ASCellNode()
        }
    }
}
