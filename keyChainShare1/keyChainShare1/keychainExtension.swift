//
//  keychainExtension.swift
//  keyChainShare1
//
//  Created by Scott Moon on 8/17/16.
//  Copyright © 2016 scott. All rights reserved.
//

import UIKit

protocol keychainClass { }

// @설  명 : 단일 앱 또는 앱과 앱간의 공유 데이터 사용하려고 간단히 만든 클래스
// @작성자 : 문상봉 (Scott Moon)
extension keychainClass where Self : NSObject {
    
    // @설  명 : 키체인 데이터 삭제
    // @작성자 : 문상봉 (Scott Moon)
    func deleteValue(accessKey: String, classKey: String) {
        let itemKey = classKey
        let keychainAccessGroupName = accessKey
        
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey,
            kSecAttrAccessGroup as String: keychainAccessGroupName
        ]
        
        let resultCode = SecItemDelete(queryDelete as CFDictionaryRef)
        
        if resultCode != noErr {
            print("지우다 에러가 발생 : 에러코드 \(resultCode)")
        }
    }
    
    // @설  명 : 키체인 데이터 추가
    // @작성자 : 문상봉 (Scott Moon)
    func addValue(accessKey: String, classKey: String, value: String) {
        
        
        guard let valueData = value.dataUsingEncoding(NSUTF8StringEncoding) else {
            print("키체인 추가 텍스트 변환 실패")
            return
        }
        
        if self.findValue(accessKey, classKey: classKey).isEmpty == false {
            self.deleteValue(accessKey, classKey: classKey)
        }
        
        let queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: classKey,
            kSecValueData as String: valueData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccessGroup as String: accessKey
        ]
        
        let resultCode = SecItemAdd(queryAdd as CFDictionaryRef, nil)
        
        if resultCode != noErr {
            print("키체인 저장하다 에러발생 : 에러코드 \(resultCode)")
        }
    }
    
    // @설  명 : 키체인 데이터 조회
    // @작성자 : 문상봉 (Scott Moon)
    func findValue(accessKey: String, classKey: String) -> String {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: classKey,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessGroup as String: accessKey
        ]
        
        var result: AnyObject?
        
        let resultCode = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(queryLoad, UnsafeMutablePointer($0))
        }
        
        if resultCode == noErr {
            if let result = result as? NSData,
                keyValue = NSString(data: result,
                                    encoding: NSUTF8StringEncoding) as? String {
                
                // Found successfully
                return keyValue
            }
        } else {
            print("키체인 데이터 조회하다 에러발생 : 에러 코드 \(resultCode)")
            return ""
        }
        return ""
    }
}




// MARK: -resultCode 에러 정의표
public enum Status: OSStatus, ErrorType {
    case Success                            = 0
    case Unimplemented                      = -4
    case DiskFull                           = -34
    case IO                                 = -36
    case OpWr                               = -49
    case Param                              = -50
    case WrPerm                             = -61
    case Allocate                           = -108
    case UserCanceled                       = -128
    case BadReq                             = -909
    case InternalComponent                  = -2070
    case NotAvailable                       = -25291
    case ReadOnly                           = -25292
    case AuthFailed                         = -25293
    case NoSuchKeychain                     = -25294
    case InvalidKeychain                    = -25295
    case DuplicateKeychain                  = -25296
    case DuplicateCallback                  = -25297
    case InvalidCallback                    = -25298
    case DuplicateItem                      = -25299
    case ItemNotFound                       = -25300
    case BufferTooSmall                     = -25301
    case DataTooLarge                       = -25302
    case NoSuchAttr                         = -25303
    case InvalidItemRef                     = -25304
    case InvalidSearchRef                   = -25305
    case NoSuchClass                        = -25306
    case NoDefaultKeychain                  = -25307
    case InteractionNotAllowed              = -25308
    case ReadOnlyAttr                       = -25309
    case WrongSecVersion                    = -25310
    case KeySizeNotAllowed                  = -25311
    case NoStorageModule                    = -25312
    case NoCertificateModule                = -25313
    case NoPolicyModule                     = -25314
    case InteractionRequired                = -25315
    case DataNotAvailable                   = -25316
    case DataNotModifiable                  = -25317
    case CreateChainFailed                  = -25318
    case InvalidPrefsDomain                 = -25319
    case InDarkWake                         = -25320
    case ACLNotSimple                       = -25240
    case PolicyNotFound                     = -25241
    case InvalidTrustSetting                = -25242
    case NoAccessForItem                    = -25243
    case InvalidOwnerEdit                   = -25244
    case TrustNotAvailable                  = -25245
    case UnsupportedFormat                  = -25256
    case UnknownFormat                      = -25257
    case KeyIsSensitive                     = -25258
    case MultiplePrivKeys                   = -25259
    case PassphraseRequired                 = -25260
    case InvalidPasswordRef                 = -25261
    case InvalidTrustSettings               = -25262
    case NoTrustSettings                    = -25263
    case Pkcs12VerifyFailure                = -25264
    case InvalidCertificate                 = -26265
    case NotSigner                          = -26267
    case PolicyDenied                       = -26270
    case InvalidKey                         = -26274
    case Decode                             = -26275
    case Internal                           = -26276
    case UnsupportedAlgorithm               = -26268
    case UnsupportedOperation               = -26271
    case UnsupportedPadding                 = -26273
    case ItemInvalidKey                     = -34000
    case ItemInvalidKeyType                 = -34001
    case ItemInvalidValue                   = -34002
    case ItemClassMissing                   = -34003
    case ItemMatchUnsupported               = -34004
    case UseItemListUnsupported             = -34005
    case UseKeychainUnsupported             = -34006
    case UseKeychainListUnsupported         = -34007
    case ReturnDataUnsupported              = -34008
    case ReturnAttributesUnsupported        = -34009
    case ReturnRefUnsupported               = -34010
    case ReturnPersitentRefUnsupported      = -34011
    case ValueRefUnsupported                = -34012
    case ValuePersistentRefUnsupported      = -34013
    case ReturnMissingPointer               = -34014
    case MatchLimitUnsupported              = -34015
    case ItemIllegalQuery                   = -34016
    case WaitForCallback                    = -34017
    case MissingEntitlement                 = -34018
    case UpgradePending                     = -34019
    case MPSignatureInvalid                 = -25327
    case OTRTooOld                          = -25328
    case OTRIDTooNew                        = -25329
    case ServiceNotAvailable                = -67585
    case InsufficientClientID               = -67586
    case DeviceReset                        = -67587
    case DeviceFailed                       = -67588
    case AppleAddAppACLSubject              = -67589
    case ApplePublicKeyIncomplete           = -67590
    case AppleSignatureMismatch             = -67591
    case AppleInvalidKeyStartDate           = -67592
    case AppleInvalidKeyEndDate             = -67593
    case ConversionError                    = -67594
    case AppleSSLv2Rollback                 = -67595
    case QuotaExceeded                      = -67596
    case FileTooBig                         = -67597
    case InvalidDatabaseBlob                = -67598
    case InvalidKeyBlob                     = -67599
    case IncompatibleDatabaseBlob           = -67600
    case IncompatibleKeyBlob                = -67601
    case HostNameMismatch                   = -67602
    case UnknownCriticalExtensionFlag       = -67603
    case NoBasicConstraints                 = -67604
    case NoBasicConstraintsCA               = -67605
    case InvalidAuthorityKeyID              = -67606
    case InvalidSubjectKeyID                = -67607
    case InvalidKeyUsageForPolicy           = -67608
    case InvalidExtendedKeyUsage            = -67609
    case InvalidIDLinkage                   = -67610
    case PathLengthConstraintExceeded       = -67611
    case InvalidRoot                        = -67612
    case CRLExpired                         = -67613
    case CRLNotValidYet                     = -67614
    case CRLNotFound                        = -67615
    case CRLServerDown                      = -67616
    case CRLBadURI                          = -67617
    case UnknownCertExtension               = -67618
    case UnknownCRLExtension                = -67619
    case CRLNotTrusted                      = -67620
    case CRLPolicyFailed                    = -67621
    case IDPFailure                         = -67622
    case SMIMEEmailAddressesNotFound        = -67623
    case SMIMEBadExtendedKeyUsage           = -67624
    case SMIMEBadKeyUsage                   = -67625
    case SMIMEKeyUsageNotCritical           = -67626
    case SMIMENoEmailAddress                = -67627
    case SMIMESubjAltNameNotCritical        = -67628
    case SSLBadExtendedKeyUsage             = -67629
    case OCSPBadResponse                    = -67630
    case OCSPBadRequest                     = -67631
    case OCSPUnavailable                    = -67632
    case OCSPStatusUnrecognized             = -67633
    case EndOfData                          = -67634
    case IncompleteCertRevocationCheck      = -67635
    case NetworkFailure                     = -67636
    case OCSPNotTrustedToAnchor             = -67637
    case RecordModified                     = -67638
    case OCSPSignatureError                 = -67639
    case OCSPNoSigner                       = -67640
    case OCSPResponderMalformedReq          = -67641
    case OCSPResponderInternalError         = -67642
    case OCSPResponderTryLater              = -67643
    case OCSPResponderSignatureRequired     = -67644
    case OCSPResponderUnauthorized          = -67645
    case OCSPResponseNonceMismatch          = -67646
    case CodeSigningBadCertChainLength      = -67647
    case CodeSigningNoBasicConstraints      = -67648
    case CodeSigningBadPathLengthConstraint = -67649
    case CodeSigningNoExtendedKeyUsage      = -67650
    case CodeSigningDevelopment             = -67651
    case ResourceSignBadCertChainLength     = -67652
    case ResourceSignBadExtKeyUsage         = -67653
    case TrustSettingDeny                   = -67654
    case InvalidSubjectName                 = -67655
    case UnknownQualifiedCertStatement      = -67656
    case MobileMeRequestQueued              = -67657
    case MobileMeRequestRedirected          = -67658
    case MobileMeServerError                = -67659
    case MobileMeServerNotAvailable         = -67660
    case MobileMeServerAlreadyExists        = -67661
    case MobileMeServerServiceErr           = -67662
    case MobileMeRequestAlreadyPending      = -67663
    case MobileMeNoRequestPending           = -67664
    case MobileMeCSRVerifyFailure           = -67665
    case MobileMeFailedConsistencyCheck     = -67666
    case NotInitialized                     = -67667
    case InvalidHandleUsage                 = -67668
    case PVCReferentNotFound                = -67669
    case FunctionIntegrityFail              = -67670
    case InternalError                      = -67671
    case MemoryError                        = -67672
    case InvalidData                        = -67673
    case MDSError                           = -67674
    case InvalidPointer                     = -67675
    case SelfCheckFailed                    = -67676
    case FunctionFailed                     = -67677
    case ModuleManifestVerifyFailed         = -67678
    case InvalidGUID                        = -67679
    case InvalidHandle                      = -67680
    case InvalidDBList                      = -67681
    case InvalidPassthroughID               = -67682
    case InvalidNetworkAddress              = -67683
    case CRLAlreadySigned                   = -67684
    case InvalidNumberOfFields              = -67685
    case VerificationFailure                = -67686
    case UnknownTag                         = -67687
    case InvalidSignature                   = -67688
    case InvalidName                        = -67689
    case InvalidCertificateRef              = -67690
    case InvalidCertificateGroup            = -67691
    case TagNotFound                        = -67692
    case InvalidQuery                       = -67693
    case InvalidValue                       = -67694
    case CallbackFailed                     = -67695
    case ACLDeleteFailed                    = -67696
    case ACLReplaceFailed                   = -67697
    case ACLAddFailed                       = -67698
    case ACLChangeFailed                    = -67699
    case InvalidAccessCredentials           = -67700
    case InvalidRecord                      = -67701
    case InvalidACL                         = -67702
    case InvalidSampleValue                 = -67703
    case IncompatibleVersion                = -67704
    case PrivilegeNotGranted                = -67705
    case InvalidScope                       = -67706
    case PVCAlreadyConfigured               = -67707
    case InvalidPVC                         = -67708
    case EMMLoadFailed                      = -67709
    case EMMUnloadFailed                    = -67710
    case AddinLoadFailed                    = -67711
    case InvalidKeyRef                      = -67712
    case InvalidKeyHierarchy                = -67713
    case AddinUnloadFailed                  = -67714
    case LibraryReferenceNotFound           = -67715
    case InvalidAddinFunctionTable          = -67716
    case InvalidServiceMask                 = -67717
    case ModuleNotLoaded                    = -67718
    case InvalidSubServiceID                = -67719
    case AttributeNotInContext              = -67720
    case ModuleManagerInitializeFailed      = -67721
    case ModuleManagerNotFound              = -67722
    case EventNotificationCallbackNotFound  = -67723
    case InputLengthError                   = -67724
    case OutputLengthError                  = -67725
    case PrivilegeNotSupported              = -67726
    case DeviceError                        = -67727
    case AttachHandleBusy                   = -67728
    case NotLoggedIn                        = -67729
    case AlgorithmMismatch                  = -67730
    case KeyUsageIncorrect                  = -67731
    case KeyBlobTypeIncorrect               = -67732
    case KeyHeaderInconsistent              = -67733
    case UnsupportedKeyFormat               = -67734
    case UnsupportedKeySize                 = -67735
    case InvalidKeyUsageMask                = -67736
    case UnsupportedKeyUsageMask            = -67737
    case InvalidKeyAttributeMask            = -67738
    case UnsupportedKeyAttributeMask        = -67739
    case InvalidKeyLabel                    = -67740
    case UnsupportedKeyLabel                = -67741
    case InvalidKeyFormat                   = -67742
    case UnsupportedVectorOfBuffers         = -67743
    case InvalidInputVector                 = -67744
    case InvalidOutputVector                = -67745
    case InvalidContext                     = -67746
    case InvalidAlgorithm                   = -67747
    case InvalidAttributeKey                = -67748
    case MissingAttributeKey                = -67749
    case InvalidAttributeInitVector         = -67750
    case MissingAttributeInitVector         = -67751
    case InvalidAttributeSalt               = -67752
    case MissingAttributeSalt               = -67753
    case InvalidAttributePadding            = -67754
    case MissingAttributePadding            = -67755
    case InvalidAttributeRandom             = -67756
    case MissingAttributeRandom             = -67757
    case InvalidAttributeSeed               = -67758
    case MissingAttributeSeed               = -67759
    case InvalidAttributePassphrase         = -67760
    case MissingAttributePassphrase         = -67761
    case InvalidAttributeKeyLength          = -67762
    case MissingAttributeKeyLength          = -67763
    case InvalidAttributeBlockSize          = -67764
    case MissingAttributeBlockSize          = -67765
    case InvalidAttributeOutputSize         = -67766
    case MissingAttributeOutputSize         = -67767
    case InvalidAttributeRounds             = -67768
    case MissingAttributeRounds             = -67769
    case InvalidAlgorithmParms              = -67770
    case MissingAlgorithmParms              = -67771
    case InvalidAttributeLabel              = -67772
    case MissingAttributeLabel              = -67773
    case InvalidAttributeKeyType            = -67774
    case MissingAttributeKeyType            = -67775
    case InvalidAttributeMode               = -67776
    case MissingAttributeMode               = -67777
    case InvalidAttributeEffectiveBits      = -67778
    case MissingAttributeEffectiveBits      = -67779
    case InvalidAttributeStartDate          = -67780
    case MissingAttributeStartDate          = -67781
    case InvalidAttributeEndDate            = -67782
    case MissingAttributeEndDate            = -67783
    case InvalidAttributeVersion            = -67784
    case MissingAttributeVersion            = -67785
    case InvalidAttributePrime              = -67786
    case MissingAttributePrime              = -67787
    case InvalidAttributeBase               = -67788
    case MissingAttributeBase               = -67789
    case InvalidAttributeSubprime           = -67790
    case MissingAttributeSubprime           = -67791
    case InvalidAttributeIterationCount     = -67792
    case MissingAttributeIterationCount     = -67793
    case InvalidAttributeDLDBHandle         = -67794
    case MissingAttributeDLDBHandle         = -67795
    case InvalidAttributeAccessCredentials  = -67796
    case MissingAttributeAccessCredentials  = -67797
    case InvalidAttributePublicKeyFormat    = -67798
    case MissingAttributePublicKeyFormat    = -67799
    case InvalidAttributePrivateKeyFormat   = -67800
    case MissingAttributePrivateKeyFormat   = -67801
    case InvalidAttributeSymmetricKeyFormat = -67802
    case MissingAttributeSymmetricKeyFormat = -67803
    case InvalidAttributeWrappedKeyFormat   = -67804
    case MissingAttributeWrappedKeyFormat   = -67805
    case StagedOperationInProgress          = -67806
    case StagedOperationNotStarted          = -67807
    case VerifyFailed                       = -67808
    case QuerySizeUnknown                   = -67809
    case BlockSizeMismatch                  = -67810
    case PublicKeyInconsistent              = -67811
    case DeviceVerifyFailed                 = -67812
    case InvalidLoginName                   = -67813
    case AlreadyLoggedIn                    = -67814
    case InvalidDigestAlgorithm             = -67815
    case InvalidCRLGroup                    = -67816
    case CertificateCannotOperate           = -67817
    case CertificateExpired                 = -67818
    case CertificateNotValidYet             = -67819
    case CertificateRevoked                 = -67820
    case CertificateSuspended               = -67821
    case InsufficientCredentials            = -67822
    case InvalidAction                      = -67823
    case InvalidAuthority                   = -67824
    case VerifyActionFailed                 = -67825
    case InvalidCertAuthority               = -67826
    case InvaldCRLAuthority                 = -67827
    case InvalidCRLEncoding                 = -67828
    case InvalidCRLType                     = -67829
    case InvalidCRL                         = -67830
    case InvalidFormType                    = -67831
    case InvalidID                          = -67832
    case InvalidIdentifier                  = -67833
    case InvalidIndex                       = -67834
    case InvalidPolicyIdentifiers           = -67835
    case InvalidTimeString                  = -67836
    case InvalidReason                      = -67837
    case InvalidRequestInputs               = -67838
    case InvalidResponseVector              = -67839
    case InvalidStopOnPolicy                = -67840
    case InvalidTuple                       = -67841
    case MultipleValuesUnsupported          = -67842
    case NotTrusted                         = -67843
    case NoDefaultAuthority                 = -67844
    case RejectedForm                       = -67845
    case RequestLost                        = -67846
    case RequestRejected                    = -67847
    case UnsupportedAddressType             = -67848
    case UnsupportedService                 = -67849
    case InvalidTupleGroup                  = -67850
    case InvalidBaseACLs                    = -67851
    case InvalidTupleCredendtials           = -67852
    case InvalidEncoding                    = -67853
    case InvalidValidityPeriod              = -67854
    case InvalidRequestor                   = -67855
    case RequestDescriptor                  = -67856
    case InvalidBundleInfo                  = -67857
    case InvalidCRLIndex                    = -67858
    case NoFieldValues                      = -67859
    case UnsupportedFieldFormat             = -67860
    case UnsupportedIndexInfo               = -67861
    case UnsupportedLocality                = -67862
    case UnsupportedNumAttributes           = -67863
    case UnsupportedNumIndexes              = -67864
    case UnsupportedNumRecordTypes          = -67865
    case FieldSpecifiedMultiple             = -67866
    case IncompatibleFieldFormat            = -67867
    case InvalidParsingModule               = -67868
    case DatabaseLocked                     = -67869
    case DatastoreIsOpen                    = -67870
    case MissingValue                       = -67871
    case UnsupportedQueryLimits             = -67872
    case UnsupportedNumSelectionPreds       = -67873
    case UnsupportedOperator                = -67874
    case InvalidDBLocation                  = -67875
    case InvalidAccessRequest               = -67876
    case InvalidIndexInfo                   = -67877
    case InvalidNewOwner                    = -67878
    case InvalidModifyMode                  = -67879
    case MissingRequiredExtension           = -67880
    case ExtendedKeyUsageNotCritical        = -67881
    case TimestampMissing                   = -67882
    case TimestampInvalid                   = -67883
    case TimestampNotTrusted                = -67884
    case TimestampServiceNotAvailable       = -67885
    case TimestampBadAlg                    = -67886
    case TimestampBadRequest                = -67887
    case TimestampBadDataFormat             = -67888
    case TimestampTimeNotAvailable          = -67889
    case TimestampUnacceptedPolicy          = -67890
    case TimestampUnacceptedExtension       = -67891
    case TimestampAddInfoNotAvailable       = -67892
    case TimestampSystemFailure             = -67893
    case SigningTimeMissing                 = -67894
    case TimestampRejection                 = -67895
    case TimestampWaiting                   = -67896
    case TimestampRevocationWarning         = -67897
    case TimestampRevocationNotification    = -67898
    case UnexpectedError                    = -99999
}