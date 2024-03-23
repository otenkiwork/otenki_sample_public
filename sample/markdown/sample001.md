# 見出し

- 1
- 2
- 3

![alt text](images/sample001/image.png)

|日付 | カテゴリー | イベントテーマ | 
|    ---:   | :---: | :--- |
|2020/6/17 | 中央 | 左 | 


<table>
  <caption>HTMLの要素</caption>
  <thead>
    <tr>
      <th>名前</th> <th>説明</th>
    </tr>
  </thead>
  <tr>
    <td> table </td> <td>テーブル</td>
  </tr>
  <tr>
    <td> caption </td> <td>テーブルのキャプション</td>
  </tr>
</table>

```mermaid
sequenceDiagram
participant goodsController as 商品表示画面Controller
participant goodsService as 商品表示画面Service
participant goodsRepository as 商品表示画面Repository

goodsController ->>+ goodsService: 文房具検索メソッド(種類, 色, メーカー)
    goodsService ->>+ goodsRepository : 文房具DBデータ検索メソッド(種類, 色, メーカー)
    goodsRepository　-->>- goodsService : 文房具データ
    goodsService　->> goodsService : 在庫数チェックメソッド
goodsService　-->>- goodsController : 画面表示用文房具データ
```

```mermaid
graph TD;
    A-->BBB;
    A-->C;
    BBB-->D;
    C-->D;
```

## マージ
```mermaid
%%{init: { 
 'gitGraph': { 'mainBranchName': 'staging' },
 'themeVariables': { 'commitLabelFontSize': '18px' }
} }%%
gitGraph
    commit id: "A1"
    commit id: "A2"
    branch feature1
    checkout feature1
    commit id: "B1"
    commit id: "B2"
    checkout staging
    commit id: "A3"
    commit id: "A4"
    checkout feature1
    merge staging id: "MERGE"
```

## リベース
```mermaid
%%{init: { 
 'gitGraph': { 'mainBranchName': 'staging' },  
 'themeVariables': { 'commitLabelFontSize': '18px' }
} }%%
gitGraph
    commit id: "A1"
    commit id: "A2"
    branch feature1
    checkout feature1
    commit id: "B1" type: REVERSE
    commit id: "B2" type: REVERSE
    checkout staging
    commit id: "A3"
    commit id: "A4"
    checkout feature1
    merge staging id: "REBASE"
    commit id: "B1'"
    commit id: "B2'"
```

