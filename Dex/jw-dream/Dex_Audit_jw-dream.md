# jw-dream

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.
swap 함수
- 31 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 32 Line : tokenY.transfer(msg.sender,outputAmount)
- 40 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 41 Line : tokenX.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 66 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 67 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 26 Line : [outputAmount = yBalance * (tokenXAmount * 999 / 1000) / (xBalance + (tokenXAmount * 999 / 1000))]
- 35 Line : [outputAmount = xBalance * (tokenYAmount * 999 / 1000) / (yBalance + (tokenYAmount * 999 / 1000))]

### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## incorrect-equality
### 설명
공격자가 쉽게 조작할 수 있는 strict equalities를 사용한다.


addLiquidity 함수
- 54 Line : [totalLiquidity == 0]

### 파급력
Impact : Medium

### 해결방안
계정의 토큰 보유량을 확인하기 위해서 strict equality를 사용하면 안된다.



## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.
addLiquidity 함수
- 66 Line : [tokenX.transferFrom(msg.sender,address(this),tokenXAmount)]
- 67 Line : [tokenY.transferFrom(msg.sender,address(this),tokenYAmount)]
- 68 Line : [balances[address(tokenX)] += tokenXAmount]
위 코드로 인해 Dex.balances에서 교차 함수 재진입이 가능하다.

### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.





## tautology
### 설명
항진식을 포함하고 있다.
swap 함수
- 20 Line : [require(bool)(tokenXAmount >= 0 || tokenYAmount >= 0)]

### 파급력
Impact : Medium

### 해결방안
값 유형 또는 비교식을 변경해서 잘못된 비교를 수정해야한다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그
addLiquidity 함수
- 66 Line : [tokenX.transferFrom(msg.sender,address(this),tokenXAmount)]
- 67 Line : [tokenY.transferFrom(msg.sender,address(this),tokenYAmount)]
- 70 Line : [LPToken_balances[msg.sender] += LPTokenAmount]

### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.
