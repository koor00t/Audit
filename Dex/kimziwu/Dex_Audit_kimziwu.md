# kimziwu

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 89 Line : input.transferFrom(msg.sender,address(this),input_amount)
- 90 Line : output.transfer(msg.sender,output_amount)


addLiquidity 함수
- 124 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 125 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

removeLiquidity 함수
- 152 Line : _tokenX.transfer(msg.sender,X)
- 153 Line : _tokenY.transfer(msg.sender,Y)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 77 Line : output_amount = Y * (tokenXAmount * 999 / 1000) / (X + (tokenXAmount * 999 / 1000))
- 83 Line :output_amount = X * (tokenYAmount * 999 / 1000) / (Y + (tokenYAmount * 999 / 1000))


### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 124 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 125 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 126 Line : transfer(msg.sender,lpToken)


removeLiquidity 함수
- 152 Line : _tokenX.transfer(msg.sender,X)
- 153 Line : _tokenY.transfer(msg.sender,Y)
- 154 Line : _burn(msg.sender,_LPTokenAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-events
### 설명
비정상적인 이벤트로 인한 재진입 버그.


addLiquidity 함수
- 124 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 125 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 126 Line : transfer(msg.sender,lpToken)


removeLiquidity 함수
- 152 Line : _tokenX.transfer(msg.sender,X)
- 153 Line : _tokenY.transfer(msg.sender,Y)
- 154 Line : _burn(msg.sender,_LPTokenAmount)

### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.
